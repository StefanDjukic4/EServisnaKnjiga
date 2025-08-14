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
    public class RadniNalogController : BaseCrudController<Model.RadinNalog, RadniNalogSerchaObject, RadniNalogInsertRequest, RadniNalogUpdateRequest>
    {
        
        public RadniNalogController(ILogger<BaseController<RadinNalog, RadniNalogSerchaObject>> logger, IRadniNalogService Service) : base(logger, Service) {
        }


        [Authorize(Roles = "Klijent")]
        [HttpGet("Klijent/Payment/{id}")]
        public virtual Task<PageResult<Model.RadinNalog>> ClientPayment(int id)
        {
            return (_Service as IRadniNalogService).ClientPayment(id);
        }


        [Authorize(Roles = "Klijent")]
        [HttpPut("Klijent/Payment")]
        public virtual Task<String> PostClientPayment(RadniNalogKlijentPlacanjeRequest request)
        {
            return (_Service as IRadniNalogService).PostClientPayment(request);
        }
    }
}