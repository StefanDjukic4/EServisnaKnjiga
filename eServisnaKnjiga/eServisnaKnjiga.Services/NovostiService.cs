using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
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
    public class NovostiService : BaseCRUDDeleteService<Model.Novosti,Database.Novosti,NovostiSerchaObject,NovostiInsertRequest,NovostiUpdateRequest>  , INovostiService
    {
        public NovostiService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Novosti> AddFilter(IQueryable<Database.Novosti> query, NovostiSerchaObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naslov))
            {
                query = query.Where(x => x.Naslov.StartsWith(search.Naslov));
            }

            if (!string.IsNullOrWhiteSpace(search?.Tekst))
            {
                query = query.Where(x => x.Tekst.StartsWith(search.Tekst));
            }

            return base.AddFilter(query, search);
        }



        public async Task<PageResult<Model.Novosti>> ClientNews()
        {
            PageResult<Model.Novosti> result = new PageResult<Model.Novosti>();

            var products = await _context.Novostis
                .ToListAsync();

            result.Count = products.Count;

            result.Result = _mapper.Map<List<Model.Novosti>>(products);

            return result;
        }
    }
}
