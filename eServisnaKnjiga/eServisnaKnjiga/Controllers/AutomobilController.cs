using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    public class KlijentiController : BaseController<Model.Klijent>
    {  
        public KlijentiController(ILogger<BaseController<Model.Klijent>> logger, IService<Model.Klijent> Service) : base(logger, Service) { }
       
    }
}