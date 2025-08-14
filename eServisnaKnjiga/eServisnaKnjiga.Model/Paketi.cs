using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Model;

public partial class Paketi
{
    public int Id { get; set; }

    public string? Naziv { get; set; }

    public string? Opis { get; set; }

    public decimal? MinimalnaCijena { get; set; }

    public decimal? MaksimalnaCijena { get; set; }

    public string? IntervalObavjesti { get; set; }

    public string? Slika { get; set; }

}
