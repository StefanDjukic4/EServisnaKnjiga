using AutoMapper;
using eServisnaKnjiga.Model;
using eServisnaKnjiga.Model.Requests;
using eServisnaKnjiga.Model.SearchObjects;
using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eServisnaKnjiga.Services
{
    public class PaketiService : BaseCRUDDeleteService<Model.Paketi,Database.Paketi,PaketiSerchaObject,PaketiInsertRequest,PaketiUpdateRequest>  , IPaketiService
    {
        public PaketiService(EServisnaKnjigaContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Paketi> AddFilter(IQueryable<Database.Paketi> query, PaketiSerchaObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }

            if (!string.IsNullOrWhiteSpace(search?.Opis))
            {
                query = query.Where(x => x.Opis.StartsWith(search.Opis));
            }

            return base.AddFilter(query, search);
        }


        public async Task<PageResult<Model.Paketi>> ClientPackages()
        {
            PageResult<Model.Paketi> result = new PageResult<Model.Paketi>();

            var products = await _context.Paketis
                .ToListAsync();

            result.Count = products.Count;

            result.Result = _mapper.Map<List<Model.Paketi>>(products);

            return result;
        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Model.Paketi> Recommend(int id)
        {   
            if (mlContext == null){
                mlContext = new MLContext();
            }

            if (model == null){
                lock (isLocked){
                    if (model == null){
                        if (!File.Exists("model.zip"))
                            throw new FileNotFoundException("Model nije treniran. Nedostaje 'model.zip'.");

                        model = mlContext.Model.Load("model.zip", out _);
                    }
                }
            }

            var packages = _context.Paketis.Where(x => x.Id != id).ToList();

            var predictionEngine = mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);

            var predictionResult = new List<Tuple<Database.Paketi, float>>();

            foreach (var package in packages){
                var prediction = predictionEngine.Predict(new ProductEntry(){
                    ProductID = (uint)id,
                    CoPurchaseProductID = (uint)package.Id
                });

                predictionResult.Add(new Tuple<Database.Paketi, float>(package, prediction.Score));
            }

            var finalResult = predictionResult
                .OrderByDescending(x => x.Item2)
                .Select(x => x.Item1)
                .Take(3)
                .ToList();

            return _mapper.Map<List<Model.Paketi>>(finalResult);

        }
    }

    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProductEntry
    {
        [KeyType(count: 3000)]
        public uint ProductID { get; set; }

        [KeyType(count: 3000)]
        public uint CoPurchaseProductID { get; set; }

        public float Label { get; set; } = 1.0f;
    }
}
