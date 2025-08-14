using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class AutomobiliInsertRequest
    {
        public string? Marka { get; set; }

        public string? Model { get; set; }

        public int? GodinaProizvodnje { get; set; }

        public string? Registracija { get; set; }

        public string? BrojSasije { get; set; }

        public int? KlijentId { get; set; }
    }
}
