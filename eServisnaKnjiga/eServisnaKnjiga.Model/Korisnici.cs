using System;
using System.Collections.Generic;
using System.Data;

namespace eServisnaKnjiga.Model;

public partial class Korisnici
{

    public string? Email { get; set; }

    public string? Lozinka { get; set; }

    public int? KlijentId { get; set; }

    public int? RoleId { get; set; }

    //public virtual Klijent? Klijent { get; set; }

    //public virtual ICollection<Obavjesti> Obavjestis { get; set; } = new List<Obavjesti>();

    public virtual Role? Role { get; set; }

}
