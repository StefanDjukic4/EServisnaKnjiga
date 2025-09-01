using AutoMapper;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Services.Database;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace eServisnaKnjiga.Services
{
    public class AutomobilService : BaseCRUDService<Model.Automobil, Database.Automobil, AutomobilSerchaObject, AutomobiliInsertRequest, AutomobiliUpdateRequest>, IAutomobilService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public AutomobilService(
            EServisnaKnjigaContext context,
            IMapper mapper,
            IHttpContextAccessor httpContextAccessor)
            : base(context, mapper)
                {
                    _httpContextAccessor = httpContextAccessor;
                }

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

            if (search?.ClientId != null)
            {
                query = query.Where(x => x.KlijentId.Equals(search.ClientId));
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

            var klijentId = int.Parse(_httpContextAccessor.HttpContext.User.FindFirst("KlijentId")!.Value);

            var products = await _context.Automobils
                .Where(x => x.KlijentId == klijentId)
                .ToListAsync();

            result.Count = products.Count;
            result.Result = _mapper.Map<List<Model.Automobil>>(products);

            return result;
        }
    }
}
