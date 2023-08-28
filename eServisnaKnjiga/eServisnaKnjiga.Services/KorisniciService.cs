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
    public class KorisniciService : BaseCRUDService<Model.Korisnici, Database.Korisnici, BaseSearchObject,KorisniciInsertRequest,KorisniciUpdateRequest>  , IKorisniciService
    {
        public KorisniciService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper){}

    }
}
