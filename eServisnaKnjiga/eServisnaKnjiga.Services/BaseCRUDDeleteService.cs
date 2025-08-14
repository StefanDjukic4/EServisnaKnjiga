using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class BaseCRUDDeleteService<T, TDb, TSearch, TInsert, TUpdate> : BaseCRUDService<T,TDb,TSearch, TInsert, TUpdate> where TDb : class where T : class where TSearch : BaseSearchObject
    {

        public BaseCRUDDeleteService(EServisnaKnjigaContext context,IMapper mapper) : base(context,mapper) {}

        public virtual async Task<T> Delete(int id)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            if (entity == null)
            {
                return null;
            }

            set.Remove(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<T>(entity);
        }

    }
}
