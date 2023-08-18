using AutoMapper;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class BaseService<T, TDb, TSearch> : IService<T, TSearch> where TDb : class where T : class where TSearch : class
    {
        protected EServisnaKnjigaContext _context;

        protected IMapper _mapper { get; set; }

        public BaseService(EServisnaKnjigaContext context,IMapper mapper) {
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<List<T>> Get(TSearch search)
        {
            var query = _context.Set<TDb>().AsQueryable();

            query = AddFilter(query,search);

            var list = await query.ToListAsync();

            return _mapper.Map<List<T>>(list);
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query,TSearch? search = null)
        {
            return query;
        }

        public virtual async Task<T> GetById(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }
    }
}
