using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class MajstoriInsertRequest
    {

        public string? Ime { get; set; }

        public string? Prezime { get; set; }

        public DateTime? DatumRodjenja { get; set; }

    }
}
