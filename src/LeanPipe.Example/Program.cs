using System.Reflection;
using LeanCode.Components;
using LeanCode.CQRS.AspNetCore;
using LeanCode.CQRS.AspNetCore.Middleware;
using LeanCode.CQRS.Security;
using LeanCode.LeanPipe.Extensions;
using LeanPipe.Example.Auth;
using LeanPipe.Example.Contracts;
using LeanPipe.Example.DataAccess;
using LeanPipe.Example.Handlers;
using LeanPipe.Example.Handlers.Authorizers;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanPipe.Example;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        builder.Services.AddSingleton<IRoleRegistration, AppRoles>();
        builder.Services.AddRouting();
        builder.Services.AddCQRS(
            new TypesCatalog(Assembly.GetExecutingAssembly()),
            new TypesCatalog(Assembly.GetExecutingAssembly())
        );
        // work-around for bug in current CoreLib version
        builder.Services.RemoveAll(typeof(CQRSSecurityMiddleware));

        builder.Services.AddTransient<AllowAuthorizedAuthorizer>();
        builder.Services.AddTopicController<Auction, AuctionTopicController>();
        // the following registers an invalid type and will throw at startup
        // builder.Services.AddTopicController<Auction, WrongTopicController>();
        // > Unhandled exception. System.InvalidOperationException: Topic controller should implement the same
        // >   notification-related interfaces as it's topic; 'WrongTopicController' is missing following implementations:
        // >   ITopicController<Auction, ItemSold>.
        builder.Services.AddTopicController<Games, GamesTopicController>();
        builder.Services.AddSingleton(new GamesContext()); // mock

        builder.Services.AddLeanPipe();
        builder.Services.AddAuthentication(AuthenticationHandler.SchemeName).AddAuthenticationHandler();

        var app = builder.Build();

        app.UseDefaultFiles();
        app.UseStaticFiles();
        app.UseAuthentication();

        app.MapRemoteCqrs(
            "/cqrs",
            cqrs =>
            {
                cqrs.Queries = _ => { };
                cqrs.Commands = _ => { };
                cqrs.Operations = _ => { };
            }
        );
        app.MapLeanPipe("/pipe");

        app.Run();
    }
}
