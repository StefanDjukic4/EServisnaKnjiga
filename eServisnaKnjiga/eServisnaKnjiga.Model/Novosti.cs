using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model
{
    public partial class Novosti
    {

        public int Id { get; set; }

        public string? Naslov { get; set; }

        public string? Tekst { get; set; }

        public DateTime? DatumObjave { get; set; }

    }
}
