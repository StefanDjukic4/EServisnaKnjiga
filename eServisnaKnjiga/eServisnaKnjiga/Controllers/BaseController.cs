using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [Route("[controller]")]
    public class BaseController<T, TSearch> : ControllerBase where T : class where TSearch : class
    {
        private readonly IService<T, TSearch> _Service;
        private readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseController(ILogger<BaseController<T, TSearch>> logger, IService<T, TSearch> Service)
        {
            _logger = logger;
            _Service = Service;
        }
        
        [HttpGet()]
        public async Task<PageResult<T>> Get([FromQuery] TSearch? search = null)
        {
            return await _Service.Get(search);
        }

        [HttpGet("{id}")] 
        public async Task<T> GetById(int id)
        {
            return await _Service.GetById(id);
        }
        
    }
}