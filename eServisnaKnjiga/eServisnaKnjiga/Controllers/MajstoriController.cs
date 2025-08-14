using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MajstoriController : BaseCrudController<Model.Majstori, MajstoriSerchaObject, MajstoriInsertRequest, MajstoriUpdateRequest>
    {
        
        public MajstoriController(ILogger<BaseController<Majstori, MajstoriSerchaObject>> logger, IMajstoriService Service) : base(logger, Service) {
        }

        
    }
}