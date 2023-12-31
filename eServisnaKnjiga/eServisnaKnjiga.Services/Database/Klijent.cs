﻿using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Services.Database;

public partial class Klijent
{
    public int Id { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public string? Telefon { get; set; }

    public string? Email { get; set; }

    public string? Adresa { get; set; }

    public virtual ICollection<Automobil> Automobils { get; set; } = new List<Automobil>();

    public virtual ICollection<Korisnici> Korisnicis { get; set; } = new List<Korisnici>();
}
