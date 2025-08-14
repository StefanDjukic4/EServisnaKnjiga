using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Model;

public partial class Majstori
{
    public int Id { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public DateTime? DatumRodjenja { get; set; }

}
