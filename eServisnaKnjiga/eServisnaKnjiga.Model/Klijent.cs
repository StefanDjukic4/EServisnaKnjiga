﻿using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Model;

public partial class Klijent
{
    public int Id { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public string? Telefon { get; set; }

    public string? Email { get; set; }

    public string? Adresa { get; set; }

}
