using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class Novosti
{
    public int Id { get; set; }

    public string? Naslov { get; set; }

    public string? Tekst { get; set; }

    public DateTime? DatumObjave { get; set; }
}
