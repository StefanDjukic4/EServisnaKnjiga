using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class Obavjesti
{
    public int Id { get; set; }

    public int? PaketId { get; set; }

    public int? KorisnikId { get; set; }

    public DateTime? Datum { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual Paketi? Paket { get; set; }
}
