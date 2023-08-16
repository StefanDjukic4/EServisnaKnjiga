using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class RezervacijaPaketi
{
    public int Id { get; set; }

    public int RezervacijaId { get; set; }

    public int PaketId { get; set; }

    public virtual Paketi Paket { get; set; } = null!;

    public virtual Rezervacije Rezervacija { get; set; } = null!;
}
