using eServisnaKnjiga.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface ICruedDeleteService<T, TSearch, TInsert, TUpdate> : ICruedService<T, TSearch, TInsert, TUpdate> where TSearch : class
    {

        Task<T> Delete(int id);
    }
}
