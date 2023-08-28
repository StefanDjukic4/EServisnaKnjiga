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
    public class KlijentService : BaseCRUDService<Model.Klijent, Database.Klijent, BaseSearchObject, KlijentInsertRequest, KlijentUpdateRequest>, IKlijentService
    {
        public KlijentService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper) { }

        public override IQueryable<Database.Klijent> AddInclude(IQueryable<Database.Klijent> query, BaseSearchObject? search = null)
        {
            query = query.Include("Korisnicis.Role");
            return base.AddInclude(query, search);
        }

        public async Task<Model.Klijent> Login(string username, string password)
        {
            var entity = await _context.Klijents.Include("Korisnicis.Role").FirstOrDefaultAsync(x => x.Korisnicis.FirstOrDefault().Email == username);

            if (entity?.Korisnicis.FirstOrDefault()?.Lozinka == password)
            {
                return _mapper.Map<Model.Klijent>(entity);
            }

            return null;
        }

    }

   
}
