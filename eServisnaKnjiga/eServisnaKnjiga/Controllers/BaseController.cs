using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [Route("[controller]")]
    public class BaseController<T> : ControllerBase where T : class
    {
        private readonly IService<T> _Service;
        private readonly ILogger<BaseController<T>> _logger;

        public BaseController(ILogger<BaseController<T>> logger, IService<T> Service)
        {
            _logger = logger;
            _Service = Service;
        }
        
        [HttpGet()]
        public async Task<IEnumerable<T>> Get()
        {
            return await _Service.Get();
        }
        
    }
}