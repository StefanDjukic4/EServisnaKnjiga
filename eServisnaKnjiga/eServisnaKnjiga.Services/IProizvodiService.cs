using eServisnaKnjiga.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IProizvodiService
    {
        Task<IList<Model.Paketi>> Get();

        Model.Paketi Insert(Model.Requests.PaketiInsertRequest request);

        Model.Paketi Update(int id,Model.Requests.PaketiUpdateRequest request);

    }
}
