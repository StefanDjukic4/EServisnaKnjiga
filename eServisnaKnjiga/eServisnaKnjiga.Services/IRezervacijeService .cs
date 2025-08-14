using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IRezervacijeService : ICruedService<Model.Rezervacije, BaseSearchObject,Model.Requests.RezervacijeInsertRequest, Model.Requests.RezervacijeUpdateRequest>
    {
        Task<Rezervacije> Accepted(int id);

        Task<Rezervacije> Canceled(int id);

        Task<Rezervacije> Modify(int id, RezervacijeUpdateRequest update);

        Task<List<string>> AllowedActions(int id);

        Task<Rezervacije> ClientRezervation(RezervacijeInsertRequest insert);

        Task<String> ClientInitialzPayment(RadniNalogKlijentPlacanjeRequest request);

        Task<Rezervacije> ClientSuccessfulPayment(int id);
    }
}
