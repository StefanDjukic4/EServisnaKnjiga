using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IAutomobilService : ICruedService<Model.Automobil, AutomobilSerchaObject, Model.Requests.AutomobiliInsertRequest, Model.Requests.AutomobiliUpdateRequest>
    {
       Task<PageResult<Model.Automobil>> ClientCars(int id);
    }
}
