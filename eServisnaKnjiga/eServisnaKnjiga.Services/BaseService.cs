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
    public class BaseService<T, TDb, TSearch> : IService<T, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        protected EServisnaKnjigaContext _context;

        protected IMapper _mapper { get; set; }

        public BaseService(EServisnaKnjigaContext context,IMapper mapper) {
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PageResult<T>> Get(TSearch search)
        {
            var query = _context.Set<TDb>().AsQueryable();

            PageResult<T> result = new PageResult<T>();

            query = AddFilter(query, search);

            query = AddInclude(query, search);

            result.Count = await query.CountAsync();

            if (search?.page.HasValue == true && search?.pageSize.HasValue == true){
                query = query.Skip(search.page.Value * search.pageSize.Value).Take(search.pageSize.Value);
            }

            var list = await query.ToListAsync();

            var tmp = _mapper.Map<List<T>>(list);

            result.Result = tmp;

            return result;
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
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
