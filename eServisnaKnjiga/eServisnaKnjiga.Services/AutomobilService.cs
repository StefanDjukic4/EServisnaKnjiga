using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class AutomobilService : BaseService<Model.Automobil, Database.Automobil>, IAutomobilService
    {
        public AutomobilService(EServisnaKnjigaContext context, IMapper mapper) 
            : base(context,mapper){}

    }
}
