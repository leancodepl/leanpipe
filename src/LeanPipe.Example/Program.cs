using System.Reflection;
using LeanCode.Components;
using LeanCode.CQRS.AspNetCore;
using LeanCode.LeanPipe.Extensions;

namespace BasicExample;

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
