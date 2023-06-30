using System.Reflection;
using LeanCode.Components;
using LeanCode.CQRS.AspNetCore;
using LeanCode.CQRS.AspNetCore.Middleware;
using LeanCode.LeanPipe.Extensions;
using LeanPipe.Example.Contracts;
using LeanPipe.Example.DataAccess;
using LeanPipe.Example.Handlers;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanPipe.Example;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        builder.Services.AddRouting();
        builder.Services.AddCQRS(
            new TypesCatalog(Assembly.GetExecutingAssembly()),
            new TypesCatalog(Assembly.GetExecutingAssembly())
        );
        // work-around for bug in current CoreLib version
        builder.Services.RemoveAll(typeof(CQRSSecurityMiddleware));

        builder.Services.AddKeysFactory<Auction>(typeof(AuctionKeysFactory));
        // the following registers an invalid type and will throw at startup
        // builder.Services.AddKeysFactory<Auction>(typeof(WrongKeysFactory));
        // > Unhandled exception. System.InvalidOperationException: Keys factory should implement the same
        // >   notification-related interfaces as it's topic; 'WrongKeysFactory' is missing following implementations:
        // >   IKeysFactory<Auction, ItemSold>.
        builder.Services.AddKeysFactory<Games>(typeof(GamesKeysFactory));
        builder.Services.AddSingleton(new GamesContext()); // mock

        builder.Services.AddLeanPipe();

        var app = builder.Build();

        app.UseDefaultFiles();
        app.UseStaticFiles();

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
