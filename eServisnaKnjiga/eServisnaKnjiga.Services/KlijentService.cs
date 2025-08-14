using AutoMapper;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using System.Text;
using Vonage.Request;
using Vonage;
using EasyNetQ;
using eServisnaKnjiga.Model;
using System.Security.Policy;

namespace eServisnaKnjiga.Services
{
    public class KlijentService : BaseCRUDService<Model.Klijent, Database.Klijent, KlijentiSerchaObject, KlijentInsertRequest, KlijentUpdateRequest>, IKlijentService
    {
        public KlijentService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Database.Klijent> AddFilter(IQueryable<Database.Klijent> query, KlijentiSerchaObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.Ime.StartsWith(search.Ime));
            }

            if (!string.IsNullOrWhiteSpace(search?.Prezime))
            {
                query = query.Where(x => x.Prezime.StartsWith(search.Prezime));
            }

            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.Klijent> AddInclude(IQueryable<Database.Klijent> query, KlijentiSerchaObject? search = null)
        {
            query = query.Include("Korisnicis.Role");
            return base.AddInclude(query, search);
        }

        public async Task<Model.Klijent> Login(string username, string password)
        {
            var entity = await _context.Klijents.Include("Korisnicis.Role").FirstOrDefaultAsync(x => x.Korisnicis.FirstOrDefault().Email == username);

            if (entity?.Korisnicis.FirstOrDefault()?.Lozinka == password)
            {
                return _mapper.Map<Model.Klijent>(entity);
            }

            return null;
        }



        public override async Task<Model.Klijent> Insert(KlijentInsertRequest request)
        {
            var password = CreatePassword(8);

            Database.Korisnici korisnik = new Database.Korisnici();

            korisnik.Lozinka = password;
            korisnik.Email = request.Email;
            korisnik.RoleId = 1;
            korisnik.Klijent = new Database.Klijent
            {
                Adresa = request.Adresa,
                Email = request.Email,
                Ime = request.Ime,
                Prezime = request.Prezime,
                Telefon = request.Telefon
            };

            var set = _context.Set<Database.Korisnici>();

            Database.Korisnici entity = _mapper.Map<Database.Korisnici>(korisnik);

            set.Add(entity);

            await _context.SaveChangesAsync();

            var smsMessage = new SmsMessage
            {
                PhoneNumber = request.Telefon,
                Text = $"Na E-Servisnu knjigu se mozete logirati uz pomoc Email: { request.Email} i lozinke za inicialno logiranje: {password}"
            };
            

            //var bus = RabbitHutch.CreateBus("host=localhost");
            //await bus.PubSub.PublishAsync(smsMessage);

            SmsPublisher.SendSms(smsMessage);

            return _mapper.Map<Model.Klijent>(korisnik.Klijent);
        }




        /*public override async Task<Model.Klijent> Insert(KlijentInsertRequest request)
        {
            var password = CreatePassword(8);

            Database.Korisnici korisnik = new Database.Korisnici();

            korisnik.Lozinka = password;
            korisnik.Email = request.Email;
            korisnik.RoleId = 1;
            korisnik.Klijent = new Database.Klijent
            {
                Adresa = request.Adresa,
                Email = request.Email,
                Ime = request.Ime,
                Prezime = request.Prezime,
                Telefon = request.Telefon
            };

            var set = _context.Set<Database.Korisnici>();

            Database.Korisnici entity = _mapper.Map<Database.Korisnici>(korisnik);

            set.Add(entity);

            await _context.SaveChangesAsync();


            var credentials = Credentials.FromApiKeyAndSecret(
                "096bbb73",
                "uhKhAXM4YXocfmEQ"
                );

            var VonageClient = new VonageClient(credentials);
            var response = VonageClient.SmsClient.SendAnSmsAsync(new Vonage.Messaging.SendSmsRequest()
            {
                To = "+387" + request.Telefon,
                From = "E-Servisna Knjiga",
                Text = "Na E-Servisnu knjigu se mozete logirati uz pomoc Email: " + request.Email + " i lozinke za inicialno logiranje: " + password
            });

            return _mapper.Map<Model.Klijent>(korisnik.Klijent);
        }*/

        public string CreatePassword(int length)
        {
            const string valid = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            while (length-- > 0)
            {
                res.Append(valid[rnd.Next(valid.Length)]);
            }
            return res.ToString();
        }

    }

   
}
