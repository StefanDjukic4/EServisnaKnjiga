using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    public class KlijentiController : BaseController<Model.Klijent, object>
    {
        public KlijentiController(ILogger<BaseController<Model.Klijent, object>> logger, IKlijentService Service) : base(logger, Service) { }

    }
}