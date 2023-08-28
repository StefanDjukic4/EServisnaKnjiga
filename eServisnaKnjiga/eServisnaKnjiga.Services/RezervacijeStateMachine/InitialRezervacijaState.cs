using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services.RezervacijeStateMachine
{
    public class InitialRezervacijaState : BaseState
    {
        public InitialRezervacijaState(IServiceProvider serviceProvider, Database.EServisnaKnjigaContext context, IMapper mapper) : base(serviceProvider ,context, mapper){}

        public override async Task<Rezervacije> Insert(RezervacijeInsertRequest request)
        {
            var set = _context.Set<Database.Rezervacije>();

            var entity = _mapper.Map<Database.Rezervacije>(request);

            entity.Status = "created";
            
            set.Add(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }


}
