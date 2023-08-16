using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class Majstori
{
    public int Id { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public DateTime? DatumRodjenja { get; set; }

    public virtual ICollection<RadniNalog> RadniNalogs { get; set; } = new List<RadniNalog>();
}
