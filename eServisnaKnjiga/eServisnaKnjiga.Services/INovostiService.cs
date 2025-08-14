using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface INovostiService : ICruedDeleteService<Model.Novosti,NovostiSerchaObject,Model.Requests.NovostiInsertRequest,Model.Requests.NovostiUpdateRequest>
    {
        Task<PageResult<Model.Novosti>> ClientNews();
    }
}
