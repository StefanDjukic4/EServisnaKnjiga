using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IKlijentService : ICruedService<Model.Klijent, KlijentiSerchaObject, Model.Requests.KlijentInsertRequest, Model.Requests.KlijentUpdateRequest>
    {
        public Task<Model.Klijent> Login(string username, string password);
    }
}
