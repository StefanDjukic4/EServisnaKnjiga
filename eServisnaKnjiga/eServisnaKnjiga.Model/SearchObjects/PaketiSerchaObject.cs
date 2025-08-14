using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.SearchObjects
{
    public class PaketiSerchaObject : BaseSearchObject
    {
        public string? Naziv { get; set; }
        public string? Opis { get; set; }
    }
}
