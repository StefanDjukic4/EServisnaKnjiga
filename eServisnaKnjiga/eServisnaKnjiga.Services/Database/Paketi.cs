using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class Paketi
{
    public int Id { get; set; }

    public string? Naziv { get; set; }

    public string? Opis { get; set; }

    public decimal? MinimalnaCijena { get; set; }

    public decimal? MaksimalnaCijena { get; set; }

    public string? IntervalObavjesti { get; set; }

    public string? Slika { get; set; }

    public virtual ICollection<Obavjesti> Obavjestis { get; set; } = new List<Obavjesti>();

    public virtual ICollection<RezervacijaPaketi> RezervacijaPaketi { get; set; } = new List<RezervacijaPaketi>();
}
