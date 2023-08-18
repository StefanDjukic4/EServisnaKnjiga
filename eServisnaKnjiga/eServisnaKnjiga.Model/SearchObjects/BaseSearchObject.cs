using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.SearchObjects
{
    public class BaseSearchObject
    {
        public int? page { get; set; }
        public int? pageSize { get; set; }
    }
}
