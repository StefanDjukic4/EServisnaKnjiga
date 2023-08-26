using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IPaketiService : ICruedService<Model.Paketi, BaseSearchObject, Model.Requests.PaketiInsertRequest, Model.Requests.PaketiUpdateRequest>
    {
        /*
        Model.Paketi Insert(Model.Requests.PaketiInsertRequest request);

        Model.Paketi Update(int id,Model.Requests.PaketiUpdateRequest request);
        */
    }
}
