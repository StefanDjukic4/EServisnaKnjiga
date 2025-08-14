using AutoMapper;
using EasyNetQ;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eServisnaKnjiga.Services.RezervacijeStateMachine
{
    public class ModifyRezervacijaState : BaseState
    {
        public ModifyRezervacijaState(IServiceProvider serviceProvider, Database.EServisnaKnjigaContext context, IMapper mapper) : base(serviceProvider, context, mapper) {}

        public override async Task<Rezervacije> Modify(int id, RezervacijeUpdateRequest request)
        {
            var set = _context.Set<Database.Rezervacije>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            entity.Status = "modify";

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<Rezervacije> Canceled(int id)
        {
            var set = _context.Set<Database.Rezervacije>();

            var entity = await set.FindAsync(id);

            entity.Status = "canceled";

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacije>(entity);
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

            var mapEntity = _mapper.Map<Model.Rezervacije>(entity);

            //var bus = RabbitHutch.CreateBus("host=localhost"); RABITMQ MQ

            //bus.PubSub.Publish(mapEntity);

            return mapEntity;
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("canceled");
            list.Add("modify");
            list.Add("accepted");

            return list;
        }

    }
}
