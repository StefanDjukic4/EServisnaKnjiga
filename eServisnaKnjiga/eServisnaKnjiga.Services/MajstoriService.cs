using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;

namespace eServisnaKnjiga.Services
{
    public class MajstoriService : BaseCRUDService<Model.Majstori, Database.Majstori, MajstoriSerchaObject, MajstoriInsertRequest, MajstoriUpdateRequest>  , IMajstoriService
    {
        public MajstoriService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper){}

        public override IQueryable<Database.Majstori> AddFilter(IQueryable<Database.Majstori> query, MajstoriSerchaObject? search = null){

            if (!string.IsNullOrWhiteSpace(search?.Ime))
            {
                query = query.Where(x => x.Ime.StartsWith(search.Ime));
            }

            if (!string.IsNullOrWhiteSpace(search?.Prezime))
            {
                query = query.Where(x => x.Prezime.StartsWith(search.Prezime));
            }

            return base.AddFilter(query, search);
        }


    }
}
