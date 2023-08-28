using eServisnaKnjiga.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using Microsoft.Identity.Client;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace eServisnaKnjiga
{
    public class BasicAuthentificationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        IKlijentService _korisniciService;

        public BasicAuthentificationHandler(IKlijentService korisniciService, IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock) : base(options, logger, encoder, clock)
        {
            _korisniciService = korisniciService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header");
            }

            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialsBytes = Convert.FromBase64String(authHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

            var username = credentials[0];
            var password = credentials[1];

            var user = await _korisniciService.Login(username, password);

            if(user==null)
            {
                return AuthenticateResult.Fail("Incorect username or password");
            }
            else
            {
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Name, user.Ime ),
                    new Claim(ClaimTypes.NameIdentifier, user.Email ),
                    new Claim(ClaimTypes.Role, user.Korisnicis.FirstOrDefault().Role.Naziv)
                };

                var identity = new ClaimsIdentity(claims, Scheme.Name);
                var principal = new ClaimsPrincipal(identity);

                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
        }
    }
}
