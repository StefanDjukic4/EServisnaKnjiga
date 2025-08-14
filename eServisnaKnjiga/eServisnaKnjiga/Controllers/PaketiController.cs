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
    public class PaketiController : BaseCrudAndDeleteController<Model.Paketi, PaketiSerchaObject, PaketiInsertRequest, PaketiUpdateRequest>
    {
        private readonly IPaketiService _paketiService;
        
        public PaketiController(ILogger<BaseCrudController<Paketi, PaketiSerchaObject, PaketiInsertRequest, PaketiUpdateRequest>> logger,IPaketiService Service) : base(logger, Service) {
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

        [Authorize(Roles = "Klijent")]
        [HttpGet("Klijent")]
        public virtual Task<PageResult<Model.Paketi>> ClientPackages()
        {
            return (_Service as IPaketiService).ClientPackages();
        }

        [HttpGet("{id}/recommend")]
        public virtual List<Model.Paketi> Recommend(int id)
        {
            return (_Service as IPaketiService).Recommend(id);
        }

    }
}