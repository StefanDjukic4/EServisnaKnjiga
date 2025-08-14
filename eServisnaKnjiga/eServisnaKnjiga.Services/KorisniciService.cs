using AutoMapper;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services.Database;

namespace eServisnaKnjiga.Services
{
    public class KorisniciService : BaseCRUDService<Model.Korisnici, Database.Korisnici, BaseSearchObject,KorisniciInsertRequest,KorisniciUpdateRequest>  , IKorisniciService
    {
        public KorisniciService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper){}

    }
}
