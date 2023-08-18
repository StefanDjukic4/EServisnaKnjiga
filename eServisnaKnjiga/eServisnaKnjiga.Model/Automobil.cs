using System;
using System.Collections.Generic;

namespace eServisnaKnjiga.Model;

public partial class Automobil
{
    public int Id { get; set; }

    public string? Marka { get; set; }

    public string? Model { get; set; }

    public int? GodinaProizvodnje { get; set; }

    public string? Registracija { get; set; }

    public string? BrojSasije { get; set; }

}
