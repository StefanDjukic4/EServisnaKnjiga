using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class ProizvodiService : IProizvodiService
    {
        EServisnaKnjigaContext _context;

        public IMapper _mapper;

        public ProizvodiService(EServisnaKnjigaContext context, IMapper mapper) {
            _context = context;
            _mapper = mapper;
        }

        List<Proizvodi> _proizvodiList = new List<Proizvodi>()
        {
            new Proizvodi() {
                ProizvodId = 0,
                ProizvodName = "Naziv0",
                Naziv = "Naziv00"
            }
        };
   

        public IList<Model.Paketi> Get()
        {   
            var list = _context.Paketis.ToList(); 
            return _mapper.Map<List<Model.Paketi>>(list);
        }
    }
}
