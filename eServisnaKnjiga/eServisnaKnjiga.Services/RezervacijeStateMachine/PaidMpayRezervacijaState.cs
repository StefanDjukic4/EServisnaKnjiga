using AutoMapper;
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
    public class PaidMpayRezervacijaState : BaseState
    {
        public PaidMpayRezervacijaState(IServiceProvider serviceProvider, Database.EServisnaKnjigaContext context, IMapper mapper) : base(serviceProvider, context, mapper) {}

        public override async Task<Rezervacije> Canceled(int id)
        {
            var set = _context.Set<Database.Rezervacije>();

            var entity = await set.FindAsync(id);

            entity.Status = "canceled";

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("canceled");

            return list;
        }
    }
}
