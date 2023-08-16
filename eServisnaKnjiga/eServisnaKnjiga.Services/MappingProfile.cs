using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile() {

            CreateMap<Database.Paketi, Model.Paketi>();
            CreateMap<Model.Requests.PaketiInsertRequest, Database.Paketi>();

        }
    }
}
