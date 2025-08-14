using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Model;

public partial class RezervacijaPaketi
{
    public int Id { get; set; }

    public int? RezervacijaId { get; set; }

    public int? PaketId { get; set; }

    public virtual PaketiNoPicture Paket { get; set; } = null!;

}
