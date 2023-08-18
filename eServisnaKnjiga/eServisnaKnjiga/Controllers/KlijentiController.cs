using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    public class KlijentiController : BaseController<Model.Klijent, BaseSearchObject>
    {
        public KlijentiController(ILogger<BaseController<Model.Klijent, BaseSearchObject>> logger, IKlijentService Service) : base(logger, Service) { }

    }
}