using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PaketiController : BaseCrudController<Model.Paketi,BaseSearchObject,PaketiInsertRequest, PaketiUpdateRequest>
    {
        private readonly IPaketiService _paketiService;
        
        public PaketiController(ILogger<BaseController<Paketi,BaseSearchObject>> logger,IPaketiService Service) : base(logger, Service) {
            _paketiService = Service;
        }

        /*
        [HttpPost]
        public Model.Paketi Insert(PaketiInsertRequest request)
        {
            return _paketiService.Insert(request);
        }

        [HttpPut("{id}")]
        public Model.Paketi Update(int id, PaketiUpdateRequest request)
        {
            return _paketiService.Update(id, request);
        }
        */
        
    }
}