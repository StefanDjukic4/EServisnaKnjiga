﻿using eServisnaKnjiga.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public interface IProizvodiService
    {
        IList<Model.Paketi> Get();

    }
}