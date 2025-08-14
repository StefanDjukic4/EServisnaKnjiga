using eServisnaKnjiga.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML.Trainers;
using Microsoft.ML;

namespace eServisnaKnjiga.Services.Jobs
{
    public class TrenirajRecommenderJob : ITrenirajRecommenderJob
    {
        private static readonly object isLocked = new object();
        private static ITransformer model;
        private static MLContext mlContext;

        private readonly EServisnaKnjigaContext _context;

        public TrenirajRecommenderJob(EServisnaKnjigaContext context)
        {
            _context = context;
        }

        public async Task PokreniTreningAsync()
        {
            lock (isLocked)
            {
                mlContext = new MLContext();

                var tempData = _context.Rezervacijes.Include("RezervacijaPaketi").ToList();
                var data = new List<ProductEntry>();

                foreach (var x in tempData)
                {
                    if (x.RezervacijaPaketi.Count > 1)
                    {
                        var distinctItemId = x.RezervacijaPaketi.Select(y => y.PaketId).ToList();

                        distinctItemId.ForEach(y =>
                        {
                            var relatedItems = x.RezervacijaPaketi.Where(z => z.PaketId != y);

                            foreach (var z in relatedItems)
                            {
                                data.Add(new ProductEntry()
                                {
                                    ProductID = (uint)y,
                                    CoPurchaseProductID = (uint)z.PaketId,
                                });
                            }
                        });
                    }
                }

                var trainData = mlContext.Data.LoadFromEnumerable(data);

                var options = new MatrixFactorizationTrainer.Options
                {
                    MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID),
                    MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID),
                    LabelColumnName = "Label",
                    LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                    Alpha = 0.01,
                    Lambda = 0.025,
                    NumberOfIterations = 100,
                    C = 0.00001
                };

                var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);
                model = est.Fit(trainData);

                // Optional: save model to disk
                mlContext.Model.Save(model, trainData.Schema, "model.zip");
            }

            await Task.CompletedTask;
        }
    }
}
