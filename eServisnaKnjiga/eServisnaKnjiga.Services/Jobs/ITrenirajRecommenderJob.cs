using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services.Jobs
{
    public interface ITrenirajRecommenderJob
    {
        Task PokreniTreningAsync();
    }
}
