using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    public class KlijentiController : BaseCrudController<Model.Klijent, BaseSearchObject, KlijentInsertRequest, KlijentUpdateRequest>
    {
        public KlijentiController(ILogger<BaseController<Model.Klijent, BaseSearchObject>> logger, IKlijentService Service) : base(logger, Service) { }

        [Authorize(Roles = "SefServisa")]
        public override Task<Klijent> Insert([FromBody] KlijentInsertRequest insert)
        {
            return base.Insert(insert);
        }
    }
}