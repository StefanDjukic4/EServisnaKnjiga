using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.SearchObjects
{
    public class MajstoriSerchaObject : BaseSearchObject
    {
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
    }
}
