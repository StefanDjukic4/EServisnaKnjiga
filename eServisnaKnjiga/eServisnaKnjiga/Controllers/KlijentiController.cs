using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    public class AutomobilController : BaseController<Model.Automobil>
    {  
        public AutomobilController(ILogger<BaseController<Automobil>> logger, IAutomobilService Service) : base(logger, Service) { }
       
    }
}