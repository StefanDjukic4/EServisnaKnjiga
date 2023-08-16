using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class RadniNalog
{
    public int Id { get; set; }

    public int? RezervacijaId { get; set; }

    public int? MajstorId { get; set; }

    public DateTime? Datum { get; set; }

    public string? Opis { get; set; }

    public decimal? Cijena { get; set; }

    public virtual Majstori? Majstor { get; set; }

    public virtual Rezervacije? Rezervacija { get; set; }
}
