using eServisnaKnjiga.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class ProizvodiService : IProizvodiService
    {
        List<Proizvodi> _proizvodiList = new List<Proizvodi>()
        {
            new Proizvodi() {
                ProizvodId = 0,
                ProizvodName = "Naziv0",
                Naziv = "Naziv00"
            }
        };
   

        public IList<Proizvodi> Get()
        {
            return _proizvodiList;
        }
    }
}
