using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services.Database;
using eServisnaKnjiga.Services.RezervacijeStateMachine;
using Microsoft.EntityFrameworkCore;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Twilio.TwiML.Voice;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace eServisnaKnjiga.Services
{
    public class RezervacijeService : BaseCRUDService<Model.Rezervacije, Database.Rezervacije, BaseSearchObject, RezervacijeInsertRequest, RezervacijeUpdateRequest>  , IRezervacijeService
    {
        public BaseState _baseState { get; set; }

        public RezervacijeService(BaseState baseState, EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }

        public override IQueryable<Database.Rezervacije> AddInclude(IQueryable<Database.Rezervacije> query, BaseSearchObject? search = null)
        {
            query = query.Include("Automobil.Klijent").Include("RezervacijaPaketi.Paket");
            return base.AddInclude(query, search);
        }

        public override Task<Model.Rezervacije> Insert(RezervacijeInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return state.Insert(insert);
        }

        public override async Task<Model.Rezervacije> GetById(int id)
        {
            var entity = await _context.Rezervacijes
                .Include(r => r.Automobil)
                    .ThenInclude(rp => rp.Klijent)
                .Include(r => r.RezervacijaPaketi)
                    .ThenInclude(rp => rp.Paket)
                .FirstOrDefaultAsync(r => r.Id == id);

            return _mapper.Map <Model.Rezervacije> (entity);
        }

        public override async Task<Model.Rezervacije> Update(int id, RezervacijeUpdateRequest update)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.Status);

            return await state.Update(id, update);
        }

        public async Task<Model.Rezervacije> Accepted(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.Status);

            return await state.Accepted(id);
        }

        public async Task<Model.Rezervacije> Modify(int id, RezervacijeUpdateRequest update)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.Status);

            return await state.Modify(id, update);
        }

        public async Task<Model.Rezervacije> Canceled(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.Status);

            return await state.Canceled(id);
        }

        public async Task<List<string>> AllowedActions (int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);
            var state = _baseState.CreateState(entity?.Status);

            return await state.AllowedActions();

        }

        public Task<Model.Rezervacije> ClientRezervation(RezervacijeInsertRequest reqest)
        {

            var state = _baseState.CreateState("initial");

            return state.Insert(reqest);
        }

        public async Task<String> ClientInitialzPayment(RadniNalogKlijentPlacanjeRequest request)
        {
            var entity = await _context.Rezervacijes.FindAsync(request.RadniNalogId);

            var state = _baseState.CreateState(entity.Status);

            return await state.ClientInitialzPayment(request);
        }

        public async Task<Model.Rezervacije> ClientSuccessfulPayment(int id)
        {
            var entity = await _context.Rezervacijes.FindAsync(id);

            var state = _baseState.CreateState(entity.Status);

            return await state.ClientSuccessfulPayment(id); ;
        }
    }

}
