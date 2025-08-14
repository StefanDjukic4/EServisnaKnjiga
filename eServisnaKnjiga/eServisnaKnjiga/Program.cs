using eServisnaKnjiga;
using eServisnaKnjiga.Filters;
using eServisnaKnjiga.Services;
using eServisnaKnjiga.Services.Jobs;
using eServisnaKnjiga.Services.Database;
using eServisnaKnjiga.Services.RezervacijeStateMachine;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Stripe;
using Hangfire;
using Microsoft.Extensions.Options;

var builder = WebApplication.CreateBuilder(args);

var stripeSecretKey = Environment.GetEnvironmentVariable("STRIPE_SECRET_KEY");
var stripePublishableKey = Environment.GetEnvironmentVariable("STRIPE_PUBLISHABLE_KEY");

// Add services to the container.

builder.Services.AddTransient<IPaketiService, PaketiService>();
builder.Services.AddTransient<IAutomobilService, AutomobilService>();
builder.Services.AddTransient<IKlijentService, KlijentService>();
builder.Services.AddTransient<INovostiService, NovostiService>();
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IMajstoriService, MajstoriService>();
builder.Services.AddTransient<IRadniNalogService, RadniNalogService>();
builder.Services.AddTransient<IRezervacijeService, RezervacijeService>();
builder.Services.AddTransient<BaseState>();
builder.Services.AddTransient<InitialRezervacijaState>();
builder.Services.AddTransient<AcceptedRezervacijaState>();
builder.Services.AddTransient<CreatedRezervacijaState>();
builder.Services.AddTransient<CanceledRezervacijaState>();
builder.Services.AddTransient<ModifyRezervacijaState>();
builder.Services.AddTransient<PaidCashRezervacijaState>();
builder.Services.AddTransient<PendingPaymentRezervacijaState>();
builder.Services.AddTransient<PaidMpayRezervacijaState>();

builder.Services.AddControllers( x =>
{
    x.Filters.Add<ErrorFilter>();
}); 
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
            },
            new string[]{}
        }
    });

});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<EServisnaKnjigaContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IPaketiService));
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthentificationHandler>("BasicAuthentication", null);

builder.Services.AddHangfire(config =>
    config.UseSqlServerStorage(connectionString)); 
builder.Services.AddHangfireServer();
builder.Services.AddScoped<ISlanjePorukaJob, SlanjePorukaJob>();
builder.Services.AddScoped<ITrenirajRecommenderJob, TrenirajRecommenderJob>();


if (!string.IsNullOrEmpty(stripeSecretKey) && !string.IsNullOrEmpty(stripePublishableKey))
{
    builder.Services.Configure<StripeSettings>(options =>
    {
        options.SecretKey = stripeSecretKey;
        options.PublishableKey = stripePublishableKey;
    });
}
else
{
    builder.Services.Configure<StripeSettings>(builder.Configuration.GetSection("Stripe"));
}

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.UseHangfireDashboard();

using (var scope = app.Services.CreateScope())
{
   var dataContext = scope.ServiceProvider.GetRequiredService<EServisnaKnjigaContext>();
   dataContext.Database.Migrate();
}

RecurringJob.AddOrUpdate<ITrenirajRecommenderJob>(
    "treniranje-recommender-modela",
    job => job.PokreniTreningAsync(),
    "0 6 * * *" // svaki dan u 06:00
);

RecurringJob.AddOrUpdate<ISlanjePorukaJob>(
    "slanje-sms-klijentima",
    job => job.IzvrsiSlanjeAsync(),
    "0 12 * * *" // svaki dan u 12:00
);

BackgroundJob.Enqueue<ITrenirajRecommenderJob>(job => job.PokreniTreningAsync());//TEST NA POKRETANJE PROGRAMA

var stripeSettings = app.Services.GetRequiredService<IOptions<StripeSettings>>().Value;
if (!string.IsNullOrEmpty(stripeSettings.SecretKey))
{
    StripeConfiguration.ApiKey = stripeSettings.SecretKey;
}

app.Run();
