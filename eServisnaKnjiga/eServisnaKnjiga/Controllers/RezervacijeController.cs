using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RezervacijeController : BaseCrudController<Model.Rezervacije,BaseSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        
        public RezervacijeController(ILogger<BaseController<Rezervacije, BaseSearchObject>> logger,IRezervacijeService Service) : base(logger, Service) {}

        [HttpPut("{id}/accepted")]
        public virtual async Task<Rezervacije> Accepted(int id)
        {
            return await (_Service as IRezervacijeService).Accepted(id);
        }
        [HttpPut("{id}/canceled")]
        public virtual async Task<Rezervacije> Canceled(int id)
        {
            return await (_Service as IRezervacijeService).Canceled(id);
        }
        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_Service as IRezervacijeService).AllowedActions(id);
        }

    }
}