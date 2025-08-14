using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eServisnaKnjiga.Controllers
{
    [Route("[controller]")]
    public class BaseCrudAndDeleteController<T, TSearch, TInsert, TUpdate> : BaseCrudController<T, TSearch, TInsert, TUpdate> where T : class where TSearch : class
    {
        protected new readonly ICruedDeleteService<T, TSearch,TInsert,TUpdate> _Service;
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseCrudAndDeleteController(ILogger<BaseCrudController<T, TSearch, TInsert, TUpdate>> logger, ICruedDeleteService<T, TSearch,TInsert,TUpdate> Service) : base (logger, Service) {
            _Service = Service;
            _logger = logger;
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "SefServisa")]
        public virtual async Task<T> Delete(int id)
        {
            return await _Service.Delete(id);
        }
        
        
    }
}