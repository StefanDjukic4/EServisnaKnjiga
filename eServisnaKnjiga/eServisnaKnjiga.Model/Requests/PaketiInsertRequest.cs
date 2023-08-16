using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class PaketiInsertRequest
    {
        public string? Naziv { get; set; }

        public string? Opis { get; set; }

        public decimal? MinimalnaCijena { get; set; }

        public decimal? MaksimalnaCijena { get; set; }

        public string? IntervalObavjesti { get; set; }

    }
}
