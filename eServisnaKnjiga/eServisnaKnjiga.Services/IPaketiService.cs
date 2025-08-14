using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IPaketiService : ICruedDeleteService<Model.Paketi, PaketiSerchaObject, Model.Requests.PaketiInsertRequest, Model.Requests.PaketiUpdateRequest>
    {
        /*
        Model.Paketi Insert(Model.Requests.PaketiInsertRequest request);

        Model.Paketi Update(int id,Model.Requests.PaketiUpdateRequest request);
        */
        Task<PageResult<Model.Paketi>> ClientPackages();

        List<Model.Paketi> Recommend(int id);
    }
}
