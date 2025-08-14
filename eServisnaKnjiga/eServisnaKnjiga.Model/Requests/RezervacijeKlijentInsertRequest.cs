using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class RezervacijeKlijentInsertRequest
    {

        public int? AutomobilId { get; set; }

        public DateTime? Datum { get; set; }

        public string? Opis { get; set; }

    }
}
