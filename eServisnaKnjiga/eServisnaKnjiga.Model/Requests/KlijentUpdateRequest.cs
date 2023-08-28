using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class KlijentUpdateRequest
    {
        public string? Telefon { get; set; }

        public string? Email { get; set; }

        public string? Adresa { get; set; }

    }
}
