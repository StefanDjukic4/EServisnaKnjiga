using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NovostiController : BaseCrudController<Model.Novosti,NovostiSerchaObject,NovostiInsertRequest, NovostiUpdateRequest>
    {
        
        public NovostiController(ILogger<BaseController<Novosti,NovostiSerchaObject>> logger,INovostiService Service) : base(logger, Service) {
        }

        
    }
}