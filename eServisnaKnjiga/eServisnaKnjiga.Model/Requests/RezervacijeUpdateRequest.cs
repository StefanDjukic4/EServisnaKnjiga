using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class RezervacijeUpdateRequest
    {

        public DateTime? Datum { get; set; }

        public string? Opis { get; set; }

        public string? Status { get; set; }

    }
}
