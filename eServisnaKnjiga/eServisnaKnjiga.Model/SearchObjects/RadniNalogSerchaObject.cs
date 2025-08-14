using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Model.SearchObjects
{
    public class RadniNalogSerchaObject : BaseSearchObject
    {
        public int? MajstorId { get; set; }
        public int? AutomobilId { get; set; }
        public DateTime? DatumOd { get; set; }
        public DateTime? DatumDo { get; set; }
    }
}
