using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [Route("[controller]")]
    public class BaseCrudController<T, TSearch, TInsert, TUpdate> : BaseController<T,TSearch> where T : class where TSearch : class
    {
        protected new readonly ICruedService<T, TSearch,TInsert,TUpdate> _Service;
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseCrudController(ILogger<BaseController<T, TSearch>> logger, ICruedService<T, TSearch,TInsert,TUpdate> Service) : base (logger, Service) {
            _Service = Service;
            _logger = logger;
        }

        [HttpPost]
        [Authorize(Roles = "SefServisa")]
        public virtual async Task<T> Insert ([FromBody]TInsert insert)
        {
            return await _Service.Insert (insert);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "SefServisa")]
        public virtual async Task<T> Update(int id, [FromBody]TUpdate update)
        {
            return await _Service.Update (id, update);
        }
        
        
    }
}