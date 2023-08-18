using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    public class AutomobilController : BaseController<Model.Automobil, AutomobilSerchaObject>
    {
        public AutomobilController(ILogger<BaseController<Automobil,AutomobilSerchaObject>> logger, IAutomobilService Service) : base(logger, Service) { }

    }
}