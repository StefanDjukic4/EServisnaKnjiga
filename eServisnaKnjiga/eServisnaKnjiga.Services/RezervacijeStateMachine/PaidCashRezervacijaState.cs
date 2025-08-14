using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eServisnaKnjiga.Services.RezervacijeStateMachine
{
    public class PaidCashRezervacijaState : BaseState
    {
        public PaidCashRezervacijaState(IServiceProvider serviceProvider, Database.EServisnaKnjigaContext context, IMapper mapper) : base(serviceProvider, context, mapper) {}


        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            return list;
        }
    }
}
