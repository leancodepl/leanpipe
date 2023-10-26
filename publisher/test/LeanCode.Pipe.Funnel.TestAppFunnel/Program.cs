using LeanCode.Logging;
using LeanCode.Pipe;
using LeanCode.Pipe.Funnel.Instance;
using MassTransit;
using Microsoft.AspNetCore.Http.Connections;

var appBuilder = WebApplication.CreateBuilder(args);
var hostBuilder = appBuilder.Host;

hostBuilder.ConfigureDefaultLogging("TestAppFunnel", new[] { typeof(Program).Assembly });

var services = appBuilder.Services;

services.AddLeanPipeFunnel();

services.AddOptions<MassTransitHostOptions>().Configure(opts => opts.WaitUntilStarted = true);
services.AddMassTransit(cfg =>
{
    cfg.ConfigureLeanPipeFunnelConsumers();

    cfg.UsingRabbitMq(
        (ctx, cfg) =>
        {
            cfg.Host("rabbitmq://guest:guest@rabbitmq-svc.default.svc.cluster.local/");
            cfg.ConfigureEndpoints(ctx);
        }
    );
});

services.AddHealthChecks();

var app = appBuilder.Build();

app.UseRouting();

app.MapHealthChecks("/health/live");
app.MapHealthChecks("/health/ready", new() { Predicate = check => check.Tags.Contains("ready"), });

app.MapLeanPipe(
    "/leanpipe",
    opts =>
    {
        opts.Transports = HttpTransportType.WebSockets;
    }
);

app.Run();
