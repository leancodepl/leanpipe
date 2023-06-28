using System.Reflection;
using LeanCode.Components;
using LeanCode.CQRS.AspNetCore;
using LeanCode.CQRS.AspNetCore.Middleware;
using LeanCode.LeanPipe;
using LeanCode.LeanPipe.Extensions;
using LeanPipe.Example.Contracts;
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
        builder.Services.AddTransient<IEnvelopeDeserializer, EnvelopeDeserializer>();
        builder.Services.AddTransient<IKeysFactory<Auction>, AuctionKeysFactory>();
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
