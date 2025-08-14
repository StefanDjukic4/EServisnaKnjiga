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
    public class AutomobilService : BaseCRUDService<Model.Automobil, Database.Automobil, AutomobilSerchaObject, AutomobiliInsertRequest, AutomobiliUpdateRequest>, IAutomobilService
    {
        public AutomobilService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper) { }
        
        public override IQueryable<Database.Automobil> AddFilter(IQueryable<Database.Automobil> query, AutomobilSerchaObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Marka))
            {
                query = query.Where(x => x.Marka.StartsWith(search.Marka));
            }

            if (!string.IsNullOrWhiteSpace(search?.BrojSasije))
            {
                query = query.Where(x => x.BrojSasije.StartsWith(search.BrojSasije));
            }

            if (!string.IsNullOrWhiteSpace(search?.Registracija))
            {
                query = query.Where(x => x.Registracija.StartsWith(search.Registracija));
            }

            if (!string.IsNullOrWhiteSpace(search?.Model))
            {
                query = query.Where(x => x.Model.StartsWith(search.Model));
            }

            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.Automobil> AddInclude(IQueryable<Database.Automobil> query, AutomobilSerchaObject? search = null)
        {
            query = query.Include("Klijent");
            return base.AddInclude(query, search);
        }

        public async Task<PageResult<Model.Automobil>> ClientCars(int id)
        {
            PageResult<Model.Automobil> result = new PageResult<Model.Automobil>();

            var products = await _context.Automobils
                .Where(x => x.KlijentId == id)
                .ToListAsync();

            result.Count = products.Count;

            result.Result = _mapper.Map<List<Model.Automobil>>(products);

            return result;
        }
    }
}
