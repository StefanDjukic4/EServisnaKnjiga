using eServisnaKnjiga.Model;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodiController : ControllerBase
    {
        private readonly IProizvodiService _pServizvodiService;
        private readonly ILogger<ProizvodiController> _logger;

        public ProizvodiController(ILogger<ProizvodiController> logger, IProizvodiService proizvodiService)
        {
            _logger = logger;
            _pServizvodiService = proizvodiService;
        }

        [HttpGet()]
        public IEnumerable<Model.Paketi> Get()
        {
            return _pServizvodiService.Get();
        }
    }
}