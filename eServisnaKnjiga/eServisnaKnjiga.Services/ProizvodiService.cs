using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
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

        public ProizvodiService(EServisnaKnjigaContext context, IMapper mapper)
        {
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


        public async Task<IList<Model.Paketi>> Get()
        {
            var list = await _context.Paketis.ToListAsync();

            return _mapper.Map<List<Model.Paketi>>(list);
        }

        Model.Paketi IProizvodiService.Insert(PaketiInsertRequest request)
        {
            var entity = new Database.Paketi();

            _context.Paketis.Add(_mapper.Map(request, entity));
            _context.SaveChanges();

            return _mapper.Map<Model.Paketi>(entity);

        }

        public Model.Paketi Update(int id, PaketiUpdateRequest request)
        {
            var entity = _context.Paketis.Find(id);

            _mapper.Map(request, entity);
            
            _context.SaveChanges();

            return _mapper.Map<Model.Paketi>(entity);
        }
    }
}
