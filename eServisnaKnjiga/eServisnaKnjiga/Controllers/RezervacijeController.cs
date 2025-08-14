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
    public class RezervacijeController : BaseCrudController<Model.Rezervacije,BaseSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>
    {
        
        public RezervacijeController(ILogger<BaseController<Rezervacije, BaseSearchObject>> logger,IRezervacijeService Service) : base(logger, Service) {}

        [HttpPut("{id}/accepted")]
        [Authorize(Roles = "SefServisa")]
        public virtual async Task<Rezervacije> Accepted(int id)
        {
            return await (_Service as IRezervacijeService).Accepted(id);
        }
        [HttpPut("{id}/canceled")]
        [Authorize(Roles = "SefServisa")]
        public virtual async Task<Rezervacije> Canceled(int id)
        {
            return await (_Service as IRezervacijeService).Canceled(id);
        }
        [HttpPut("{id}/modify")]
        [Authorize(Roles = "SefServisa")]

        public virtual async Task<Rezervacije> Update(int id, [FromBody] RezervacijeUpdateRequest update)
        {
            return await (_Service as IRezervacijeService).Modify(id,update);
        }
        [HttpGet("{id}/allowedActions")]
        [Authorize(Roles = "SefServisa")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_Service as IRezervacijeService).AllowedActions(id);
        }

        [Authorize(Roles = "Klijent")]
        [HttpPost("Klijent")]
        public virtual Task<Rezervacije> ClientRezervation(RezervacijeInsertRequest insert)
        {
            return (_Service as IRezervacijeService).ClientRezervation(insert);
        }

        [Authorize(Roles = "Klijent")]
        [HttpPost("Klijent/initialzPayment")]
        public virtual Task<String> ClientInitialzPayment(RadniNalogKlijentPlacanjeRequest request)
        {
            return (_Service as IRezervacijeService).ClientInitialzPayment(request);
        }

        [Authorize(Roles = "Klijent")]
        [HttpPut("{id}/Klijent/successfulPayment")]
        public virtual Task<Rezervacije> ClientSuccessfulPayment(int id)
        {
            return (_Service as IRezervacijeService).ClientSuccessfulPayment(id);
        }

    }
}