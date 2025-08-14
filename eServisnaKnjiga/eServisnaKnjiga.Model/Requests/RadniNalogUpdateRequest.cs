using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class RadniNalogUpdateRequest
    {

        public int? RezervacijaId { get; set; }

        public int? MajstorId { get; set; }

        public DateTime? Datum { get; set; }

        public string? Opis { get; set; }

        public decimal? Cijena { get; set; }

    }
}
