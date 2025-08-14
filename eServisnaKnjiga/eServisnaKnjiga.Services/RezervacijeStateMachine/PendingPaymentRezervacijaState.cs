using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using Microsoft.EntityFrameworkCore;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eServisnaKnjiga.Services.RezervacijeStateMachine
{
    public class PendingPaymentRezervacijaState : BaseState
    {
        public PendingPaymentRezervacijaState(IServiceProvider serviceProvider, Database.EServisnaKnjigaContext context, IMapper mapper) : base(serviceProvider, context, mapper) {}

        public override async Task<Rezervacije> Canceled(int id)
        {
            var set = _context.Set<Database.Rezervacije>();

            var entity = await set.FindAsync(id);

            entity.Status = "canceled";

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<String> ClientInitialzPayment(RadniNalogKlijentPlacanjeRequest request)
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

            return intent.ClientSecret;
        }

        public override async Task<Model.Rezervacije> ClientSuccessfulPayment(int id)
        {
            var rezervacije = await _context.Rezervacijes
                .Where(x => x.Id == id)
                .FirstOrDefaultAsync();

            if (rezervacije == null)
                throw new UserException("Rezervacija nije pronađena.");

            rezervacije.Status = "paid_mpay";
            //rezervacije.StripePaymentIntentId = intent.Id;

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacije>(rezervacije);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            return list;
        }
    }
}
