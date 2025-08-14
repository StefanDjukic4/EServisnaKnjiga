using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;

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

            if (request.packageIdList != null && request.packageIdList.Any())
            {
                var rezervacijaPaketi = request.packageIdList.Select(paketId => new Database.RezervacijaPaketi
                {
                    RezervacijaId = entity.Id,
                    PaketId = paketId
                }).ToList();

                _context.Set<Database.RezervacijaPaketi>().AddRange(rezervacijaPaketi);
                await _context.SaveChangesAsync();
            }   

            return _mapper.Map<Model.Rezervacije>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("insert");

            return list;
        }
    }


}
