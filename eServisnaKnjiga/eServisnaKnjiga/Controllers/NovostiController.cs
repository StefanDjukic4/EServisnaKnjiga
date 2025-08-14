using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NovostiController : BaseCrudAndDeleteController<Model.Novosti,NovostiSerchaObject,NovostiInsertRequest, NovostiUpdateRequest>
    {
        
        public NovostiController(ILogger<BaseCrudAndDeleteController<Novosti,NovostiSerchaObject, NovostiInsertRequest, NovostiUpdateRequest>> logger,INovostiService Service) : base(logger, Service) {
        }

        [Authorize(Roles = "Klijent")]
        [HttpGet("Klijent")]
        public virtual Task<PageResult<Model.Novosti>> ClientNews()
        {
            return (_Service as INovostiService).ClientNews();
        }
    }
}