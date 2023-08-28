using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : BaseCrudController<Model.Korisnici, BaseSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        
        public KorisniciController(ILogger<BaseController<Korisnici, BaseSearchObject>> logger, IKorisniciService Service) : base(logger, Service) {
        }

        
    }
}