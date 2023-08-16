using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class Role
{
    public int Id { get; set; }

    public string? Naziv { get; set; }

    public virtual ICollection<Korisnici> Korisnicis { get; set; } = new List<Korisnici>();
}
