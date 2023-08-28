using AutoMapper;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services.RezervacijeStateMachine
{
    public class BaseState
    {
        protected EServisnaKnjigaContext _context;

        IServiceProvider _serviceProvider;

        protected IMapper _mapper { get; set; }

        public BaseState(IServiceProvider serviceProvider, EServisnaKnjigaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Task<Model.Rezervacije> Insert(RezervacijeInsertRequest request)
        {
            throw new Exception("Not allowed");
        }
        public virtual Task<Model.Rezervacije> Update(int id, RezervacijeUpdateRequest request)
        {
            throw new Exception("Not allowed");
        }
        public virtual Task<Model.Rezervacije> Accepted(int id)
        {
            throw new Exception("Not allowed");
        }
        public virtual Task<Model.Rezervacije> Canceled(int id)
        {
            throw new Exception("Not allowed");
        }
        public virtual Task<Model.Rezervacije> Delete(int id)
        {
            throw new Exception("Not allowed");
        }

        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialRezervacijaState>();
                    break;
                case "created":
                    return _serviceProvider.GetService<CreatedRezervacijaState>();
                    break;
                case "accepted":
                    return _serviceProvider.GetService<AcceptedRezervacijaState>();
                    break;
                case "canceled":
                    return _serviceProvider.GetService<CanceledRezervacijaState>();
                    break;
                default:
                    throw new Exception("Not allowed");

            }
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }
    }
}
