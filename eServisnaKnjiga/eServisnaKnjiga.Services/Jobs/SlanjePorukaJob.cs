using EasyNetQ;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services.Jobs
{
    public class SlanjePorukaJob : ISlanjePorukaJob
    {
        private readonly EServisnaKnjigaContext _context;

        public SlanjePorukaJob(EServisnaKnjigaContext context)
        {
            _context = context;
        }

        public async Task IzvrsiSlanjeAsync()
        {

            
            var danas = DateTime.Today;

            var sutra = danas.AddDays(1);

            var obavjestiZaDanas = await _context.Obavjestis
                .Include(o => o.Korisnik)
                    .ThenInclude(k => k.Klijent)
                .Include(o => o.Paket)
                .Where(o => o.Datum.HasValue && o.Datum.Value >= danas && o.Datum.Value < sutra)
                .ToListAsync();

            var bus = RabbitHutch.CreateBus("host=localhost");

            foreach (var obavjest in obavjestiZaDanas)
            {
                var sms = new SmsMessage
                {
                    PhoneNumber = obavjest.Korisnik.Klijent.Telefon,
                    Text = "Napomena za redovan servis vezan za paket: " + obavjest.Paket.Naziv
                };

                await bus.PubSub.PublishAsync(sms);
            }
        }
    }
}
