using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class Rezervacije
{
    public int Id { get; set; }

    public int? AutomobilId { get; set; }

    public DateTime? Datum { get; set; }

    public string? Opis { get; set; }

    public string? Status { get; set; }

    public virtual Automobil? Automobil { get; set; }

    public virtual ICollection<RadniNalog> RadniNalogs { get; set; } = new List<RadniNalog>();

    public virtual ICollection<RezervacijaPaketi> RezervacijaPaketi { get; set; } = new List<RezervacijaPaketi>();
}
