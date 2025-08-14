using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IMajstoriService : ICruedService<Model.Majstori, MajstoriSerchaObject,Model.Requests.MajstoriInsertRequest, Model.Requests.MajstoriUpdateRequest>
    {
        
    }
}
