using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class Automobil
{
    public int Id { get; set; }

    public string? Marka { get; set; }

    public string? Model { get; set; }

    public int? GodinaProizvodnje { get; set; }

    public string? Registracija { get; set; }

    public string? BrojSasije { get; set; }

    public int? KlijentId { get; set; }

    public virtual Klijent? Klijent { get; set; }

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();
}
