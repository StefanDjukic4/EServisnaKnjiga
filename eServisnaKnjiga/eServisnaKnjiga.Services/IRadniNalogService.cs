using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IRadniNalogService : ICruedService<Model.RadinNalog, RadniNalogSerchaObject, Model.Requests.RadniNalogInsertRequest, Model.Requests.RadniNalogUpdateRequest>
    {
        Task<PageResult<Model.RadinNalog>> ClientPayment(int id);

        Task<String> PostClientPayment(RadniNalogKlijentPlacanjeRequest request);
    }
}
