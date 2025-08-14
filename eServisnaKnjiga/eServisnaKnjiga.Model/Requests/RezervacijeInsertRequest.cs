using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class RezervacijeInsertRequest
    {

        public int? AutomobilId { get; set; }

        public DateTime? Datum { get; set; }

        public string? Opis { get; set; }

        public string? Status { get; set; }

        public List<int>? packageIdList { get; set; }

    }
}
