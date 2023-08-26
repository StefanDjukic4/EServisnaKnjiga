using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class PaketiService : BaseCRUDService<Model.Paketi,Database.Paketi,BaseSearchObject,PaketiInsertRequest,PaketiUpdateRequest>  , IPaketiService
    {
        public PaketiService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper)
        {
        }
        /*
        Model.Paketi IPaketiService.Insert(PaketiInsertRequest request)
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
        */
    }
}
