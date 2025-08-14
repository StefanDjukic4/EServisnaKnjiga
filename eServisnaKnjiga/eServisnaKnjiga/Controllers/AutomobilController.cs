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
    public class AutomobilController : BaseCrudController<Model.Automobil, AutomobilSerchaObject, AutomobiliInsertRequest, AutomobiliUpdateRequest>
    
    {
        public AutomobilController(ILogger<BaseController<Automobil,AutomobilSerchaObject>> logger, IAutomobilService Service) : base(logger, Service) { }

        [Authorize(Roles = "Klijent")]
        [HttpGet("Klijent/{id}")]
        public virtual Task<PageResult<Model.Automobil>> ClientCars(int id)
        {
            return (_Service as IAutomobilService).ClientCars(id);
        }
    }
}