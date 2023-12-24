using eServisnaKnjiga;
using eServisnaKnjiga.Filters;
using eServisnaKnjiga.Services;
using eServisnaKnjiga.Services.Database;
using eServisnaKnjiga.Services.RezervacijeStateMachine;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IPaketiService, PaketiService>();
builder.Services.AddTransient<IAutomobilService, AutomobilService>();
builder.Services.AddTransient<IKlijentService, KlijentService>();
builder.Services.AddTransient<INovostiService, NovostiService>();
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IRezervacijeService, RezervacijeService>();
builder.Services.AddTransient<BaseState>();
builder.Services.AddTransient<InitialRezervacijaState>();
builder.Services.AddTransient<AcceptedRezervacijaState>();
builder.Services.AddTransient<CreatedRezervacijaState>();
builder.Services.AddTransient<CanceledRezervacijaState>();

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

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<EServisnaKnjigaContext>();
    //dataContext.Database.EnsureCreated();
    dataContext.Database.Migrate();
}

app.Run();
