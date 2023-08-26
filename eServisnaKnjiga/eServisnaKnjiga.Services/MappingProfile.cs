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
            CreateMap<Model.Requests.PaketiUpdateRequest, Database.Paketi>();
            CreateMap<Database.Automobil, Model.Automobil>();
            CreateMap<Database.Klijent, Model.Klijent>();
            CreateMap<Database.Korisnici, Model.Korisnici>();
            CreateMap<Database.Role, Model.Role>();

        }
    }
}
