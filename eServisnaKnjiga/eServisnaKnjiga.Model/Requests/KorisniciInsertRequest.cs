using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.Requests
{
    public class KorisniciInsertRequest
    {

        public string? Email { get; set; }

        public string? Lozinka { get; set; }

        public int? KlijentId { get; set; }

        public int? RoleId { get; set; }

    }
}
