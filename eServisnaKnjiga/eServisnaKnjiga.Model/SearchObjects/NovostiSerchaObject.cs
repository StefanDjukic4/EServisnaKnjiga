using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.SearchObjects
{
    public class NovostiSerchaObject : BaseSearchObject
    {
        public string? Naslov { get; set; }
        public string? Tekst { get; set; }
    }
}
