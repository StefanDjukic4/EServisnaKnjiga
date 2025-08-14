using AutoMapper;
using Azure.Core;
using EasyNetQ;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eServisnaKnjiga.Services.RezervacijeStateMachine
{
    public class CreatedRezervacijaState : BaseState
    {
        public CreatedRezervacijaState(IServiceProvider serviceProvider, Database.EServisnaKnjigaContext context, IMapper mapper) : base(serviceProvider, context, mapper) { }

        public override async Task<Rezervacije> Modify(int id, RezervacijeUpdateRequest request)
        {
            var set = _context.Set<Database.Rezervacije>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            entity.Status = "modify";

            await _context.SaveChangesAsync();


            if (entity.Automobil == null)
            {
                await _context.Entry(entity).Reference(r => r.Automobil).LoadAsync();
            }

            if (entity.Automobil?.Klijent == null)
            {
                await _context.Entry(entity.Automobil).Reference(a => a.Klijent).LoadAsync();
            }

            var mapEntity = _mapper.Map<Model.Rezervacije>(entity);

            var bus = RabbitHutch.CreateBus("host=localhost");
            var sms = new SmsMessage
            {
                PhoneNumber = mapEntity.Automobil.Klijent.Telefon,
                Text = $"Vasa rezervacija za vozilo {mapEntity.Automobil.Marka}, registarnskih oznaka {mapEntity.Automobil.Registracija} je pomjerena na termin {mapEntity.Datum}"
            };

            return mapEntity;
        }

        public override async Task<Rezervacije> Accepted(int id)
        {
            var set = _context.Set<Database.Rezervacije>();

            var entity = await set.FindAsync(id);

            entity.Status = "accepted";

            await _context.SaveChangesAsync();

            /*
            var factory = new ConnectionFactory { HostName = "localhost" };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "hello",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            const string message = "Hello Wordl!";//brabaciti u JSON
            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "hello",
                                 basicProperties: null,
                                 body: body);
            */


            if (entity.Automobil == null)
            {
                await _context.Entry(entity).Reference(r => r.Automobil).LoadAsync();
            }

            if (entity.Automobil?.Klijent == null)
            {
                await _context.Entry(entity.Automobil).Reference(a => a.Klijent).LoadAsync();
            }

            var mapEntity = _mapper.Map<Model.Rezervacije>(entity);

            var bus = RabbitHutch.CreateBus("host=localhost");
            var sms = new SmsMessage
            {
                PhoneNumber = mapEntity.Automobil.Klijent.Telefon,
                Text = $"Vasa rezervacija za vozilo {mapEntity.Automobil.Marka}, registarnskih oznaka {mapEntity.Automobil.Registracija} je prihvacena u terminu {mapEntity.Datum}"
            };

            await bus.PubSub.PublishAsync(sms);

            return mapEntity;
        }

        public override async Task<Rezervacije> Canceled(int id)
        {
            var set = _context.Set<Database.Rezervacije>();

            var entity = await set.FindAsync(id);

            entity.Status = "canceled";

            await _context.SaveChangesAsync();


            if (entity.Automobil == null)
            {
                await _context.Entry(entity).Reference(r => r.Automobil).LoadAsync();
            }

            if (entity.Automobil?.Klijent == null)
            {
                await _context.Entry(entity.Automobil).Reference(a => a.Klijent).LoadAsync();
            }

            var mapEntity = _mapper.Map<Model.Rezervacije>(entity);

            var bus = RabbitHutch.CreateBus("host=localhost");
            var sms = new SmsMessage
            {
                PhoneNumber = mapEntity.Automobil.Klijent.Telefon,
                Text = $"Vasa rezervacija za vozilo {mapEntity.Automobil.Marka}, registarnskih oznaka {mapEntity.Automobil.Registracija}, je odbijena za termin {mapEntity.Datum}"
            };

            return mapEntity;
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("modify");
            list.Add("accepted");
            list.Add("canceled");

            //Disabled polja sa ovim??

            return list;
        }
    }
}
