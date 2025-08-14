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
            CreateMap<Database.Paketi, Model.PaketiNoPicture>();
            CreateMap<Model.Requests.PaketiInsertRequest, Database.Paketi>();
            CreateMap<Model.Requests.PaketiUpdateRequest, Database.Paketi>();
            CreateMap<Database.Automobil, Model.Automobil>();
            CreateMap<Database.Klijent, Model.Klijent>();
            CreateMap<Model.Requests.KlijentInsertRequest, Database.Klijent>();
            CreateMap<Model.Requests.KlijentUpdateRequest, Database.Klijent>();
            CreateMap<Database.Role, Model.Role>();
            CreateMap<Database.Novosti, Model.Novosti>();
            CreateMap<Model.Requests.NovostiInsertRequest, Database.Novosti>();
            CreateMap<Model.Requests.NovostiUpdateRequest, Database.Novosti>();
            CreateMap<Database.Rezervacije, Model.Rezervacije>();
            CreateMap<Database.RezervacijaPaketi, Model.RezervacijaPaketi>();
            CreateMap<Model.Requests.RezervacijeInsertRequest, Database.Rezervacije>();
            CreateMap<Model.Requests.RezervacijeUpdateRequest, Database.Rezervacije>();
            CreateMap<Database.Korisnici, Model.Korisnici>();
            CreateMap<Model.Requests.KorisniciInsertRequest, Database.Korisnici>();
            CreateMap<Model.Requests.KorisniciUpdateRequest, Database.Korisnici>();
            CreateMap<Database.Automobil, Model.Automobil>();
            CreateMap<Model.Requests.AutomobiliInsertRequest, Database.Automobil>();
            CreateMap<Model.Requests.AutomobiliUpdateRequest, Database.Automobil>();
            CreateMap<Database.Majstori, Model.Majstori>();
            CreateMap<Model.Requests.MajstoriInsertRequest, Database.Majstori>();
            CreateMap<Model.Requests.MajstoriUpdateRequest, Database.Majstori>();
            CreateMap<Database.RadniNalog, Model.RadinNalog>();
            CreateMap<Model.Requests.RadniNalogInsertRequest, Database.RadniNalog>();
            CreateMap<Model.Requests.RadniNalogUpdateRequest, Database.RadniNalog>();
            CreateMap<Database.Klijent, Model.KlijentNoKorisnik>();

        }
    }
}
