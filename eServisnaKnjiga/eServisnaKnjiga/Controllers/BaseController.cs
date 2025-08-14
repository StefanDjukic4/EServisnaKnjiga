using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [Route("[controller]")]
    [Authorize]
    public class BaseController<T, TSearch> : ControllerBase where T : class where TSearch : class
    {
        protected readonly IService<T, TSearch> _Service;
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseController(ILogger<BaseController<T, TSearch>> logger, IService<T, TSearch> Service)
        {
            _logger = logger;
            _Service = Service;
        }
        
        [HttpGet()]
        [Authorize(Roles = "SefServisa")]
        public async Task<PageResult<T>> Get([FromQuery] TSearch? search = null)
        {
            return await _Service.Get(search);
        }

        [HttpGet("{id}")]
        [Authorize(Roles = "SefServisa")]
        public async Task<T> GetById(int id)
        {
            return await _Service.GetById(id);
        }
        
    }
}