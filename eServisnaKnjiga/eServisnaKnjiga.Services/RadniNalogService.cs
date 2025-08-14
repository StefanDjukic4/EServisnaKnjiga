using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services.Database;
using eServisnaKnjiga.Services.RezervacijeStateMachine;
using Microsoft.EntityFrameworkCore;
using Stripe;
using Stripe.Climate;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class RadniNalogService : BaseCRUDService<Model.RadinNalog, Database.RadniNalog, RadniNalogSerchaObject, RadniNalogInsertRequest, RadniNalogUpdateRequest>  , IRadniNalogService
    {
        public RadniNalogService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper){}

        public override IQueryable<Database.RadniNalog> AddInclude(IQueryable<Database.RadniNalog> query, RadniNalogSerchaObject? search = null)
        {

            query = query.Include("Majstor");
            query = query.Include("Rezervacija.Automobil.Klijent");
            query = query.Include("Rezervacija.RezervacijaPaketi.Paket");
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.RadniNalog> AddFilter(IQueryable<Database.RadniNalog> query, RadniNalogSerchaObject? search = null)
        {

            if (search != null && search.MajstorId != null)
            {
                query = query.Where(x => x.MajstorId.Equals(search.MajstorId));
            }

            if (search != null && search.AutomobilId != null)
            {
                query = query.Where(x => x.Rezervacija != null
                                      && x.Rezervacija.Automobil != null
                                      && x.Rezervacija.Automobil.Id == search.AutomobilId);
            }

            if (search?.DatumOd != null)
            {
                query = query.Where(x => x.Datum >= search.DatumOd);
            }

            if (search?.DatumDo != null)
            {
                query = query.Where(x => x.Datum <= search.DatumDo);
            }

            return base.AddFilter(query, search);
        }

        public override async Task<Model.RadinNalog> Insert(RadniNalogInsertRequest insert)
        {
            var entityRezervacija = await _context.Rezervacijes.FindAsync(insert.RezervacijaId);

            if (entityRezervacija != null)
            {
                if (insert.NacinPlacanja.Equals("Kes"))
                    entityRezervacija.Status = "paid_cash";
                else if (insert.NacinPlacanja.Equals("M_placanje"))
                    entityRezervacija.Status = "pending_payment";

                await _context.SaveChangesAsync();
            }
            var set = _context.Set<Database.RadniNalog>();

            Database.RadniNalog entity = _mapper.Map<Database.RadniNalog>(insert);

            set.Add(entity);

            await _context.SaveChangesAsync();

            if (entity.Rezervacija.Automobil == null)
            {
                await _context.Entry(entity.Rezervacija).Reference(r => r.Automobil).LoadAsync();
            }

            if (entity.Rezervacija.Automobil?.Klijent == null)
            {
                await _context.Entry(entity.Rezervacija.Automobil).Reference(a => a.Klijent).LoadAsync();
            }

            if (entity.Rezervacija.Automobil.Klijent?.Korisnicis == null ||
                !entity.Rezervacija.Automobil.Klijent.Korisnicis.Any())
            {
                await _context.Entry(entity.Rezervacija.Automobil.Klijent).Collection(k => k.Korisnicis).LoadAsync();
            }

            if (entity.Rezervacija.RezervacijaPaketi == null ||
                !entity.Rezervacija.RezervacijaPaketi.Any())
            {
                await _context.Entry(entity.Rezervacija).Collection(r => r.RezervacijaPaketi).LoadAsync();
            }

            int korisnikId = entity.Rezervacija.Automobil.Klijent.Korisnicis.First().Id;

            var setObavjesti = _context.Set<Database.Obavjesti>();

            foreach (var paket in entity.Rezervacija.RezervacijaPaketi)
            {
                if (paket.Paket == null)
                {
                    await _context.Entry(paket).Reference(rp => rp.Paket).LoadAsync();
                }
                int interval = 0;
                if (!string.IsNullOrWhiteSpace(paket.Paket.IntervalObavjesti) &&
                    int.TryParse(paket.Paket.IntervalObavjesti, out interval))
                {
                    var obavjestiEntity = new Database.Obavjesti
                    {
                        PaketId = paket.Paket.Id,
                        KorisnikId = korisnikId,
                        Datum = DateTime.Now.AddMonths(interval)
                    };

                    setObavjesti.Add(obavjestiEntity);
                }
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.RadinNalog>(entity);
        }

        public async Task<PageResult<Model.RadinNalog>> ClientPayment(int id)
        {
            PageResult<Model.RadinNalog> result = new PageResult<Model.RadinNalog>();

            var products = await _context.RadniNalogs
                .Include("Majstor")
                .Include("Rezervacija.Automobil.Klijent")
                .Include("Rezervacija.RezervacijaPaketi.Paket")
                .Where(x => x.Rezervacija != null &&
                            x.Rezervacija.Automobil != null &&
                            x.Rezervacija.Automobil.KlijentId == id &&
                            x.Rezervacija.Status == "pending_payment")
                .ToListAsync();

            result.Count = products.Count;

            result.Result = _mapper.Map<List<Model.RadinNalog>>(products);

            return result;
        }

        public async Task<String> PostClientPayment(RadniNalogKlijentPlacanjeRequest request)
        {
            PageResult<Model.RadinNalog> result = new PageResult<Model.RadinNalog>();
            var service = new PaymentIntentService();

            var intent = await service.CreateAsync(new PaymentIntentCreateOptions
            {
                Amount = (long)(request.Cijena * 100),
                Currency = "bam",
                PaymentMethodTypes = new List<string> { "card" },
                Metadata = new Dictionary<string, string>
                    {
                        { "radniNalogId", request.RadniNalogId.ToString() }
                    }
            });

            //var radniNalog = await _context.Rezervacijes
            //    .Where(x => x.Id == request.RadniNalogId)
            //    .FirstOrDefaultAsync();

            //if (radniNalog == null)
              //  throw new UserException("Radni nalog nije pronađen.");

            // (opcionalno) update status
            //radniNalog.Status = "paid_mpay";
            //radniNalog.StripePaymentIntentId = intent.Id;

            //await _context.SaveChangesAsync();

            //result.Count = 1; 
            
            //var mapped = _mapper.Map<Model.RadinNalog>(new RadinNalog { Id = 1, StripeClientSecret = intent.ClientSecret });

            //result.Result = new List<Model.RadinNalog> { mapped };

            return intent.ClientSecret;
        }


    }
}
