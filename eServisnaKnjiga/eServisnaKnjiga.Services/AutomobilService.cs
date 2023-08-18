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
    public class AutomobilService : BaseService<Model.Automobil, Database.Automobil, AutomobilSerchaObject>, IAutomobilService
    {
        public AutomobilService(EServisnaKnjigaContext context, IMapper mapper) 
            : base(context,mapper){}

        public override async Task<List<Model.Automobil>> Get(AutomobilSerchaObject search)
        {
           
            var query = _context.Set<Database.Automobil>().AsQueryable();

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

            var list = await query.ToListAsync();

            return _mapper.Map<List<Model.Automobil>>(list);
        }

    }
}
