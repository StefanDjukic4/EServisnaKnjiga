using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Model;

public partial class RadinNalog
{
    public int Id { get; set; }

    public DateTime? Datum { get; set; }

    public string? Opis { get; set; }

    public decimal? Cijena { get; set; }

    public virtual Majstori? Majstor { get; set; }

    public virtual Rezervacije? Rezervacija { get; set; }

    public string? StripeClientSecret { get; set; }

}
