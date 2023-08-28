using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IKorisniciService : ICruedService<Model.Korisnici,BaseSearchObject,Model.Requests.KorisniciInsertRequest,Model.Requests.KorisniciUpdateRequest>
    {
        
    }
}
