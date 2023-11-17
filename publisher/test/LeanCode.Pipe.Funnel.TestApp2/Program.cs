using LeanCode.Logging;
using LeanCode.Pipe;
using LeanCode.Pipe.Funnel.FunnelledService;
using LeanCode.Pipe.Funnel.TestApp2;
using MassTransit;

var appBuilder = WebApplication.CreateBuilder(args);
var hostBuilder = appBuilder.Host;

hostBuilder.ConfigureDefaultLogging("TestApp2", new[] { typeof(Program).Assembly });

var services = appBuilder.Services;

services.AddFunnelledLeanPipe(new(typeof(Topic2)), new(typeof(Topic2Keys)));

services.AddOptions<MassTransitHostOptions>().Configure(opts => opts.WaitUntilStarted = true);
services.AddMassTransit(cfg =>
{
    cfg.AddFunnelledLeanPipeConsumers("TestApp2", new[] { typeof(Program).Assembly });

    cfg.UsingRabbitMq(
        (ctx, cfg) =>
        {
            cfg.Host(appBuilder.Configuration.GetValue<string>("MassTransit:RabbitMq:Url"));
            cfg.ConfigureEndpoints(ctx);
        }
    );
});

services.AddHealthChecks();

using var app = appBuilder.Build();

app.UseRouting();

app.MapHealthChecks("/health/live");
app.MapHealthChecks("/health/ready", new() { Predicate = check => check.Tags.Contains("ready") });

app.MapPost(
    "/publish",
    async (HttpContext ctx, Topic2 topic, ILeanPipePublisher<Topic2> publisher) =>
        await publisher
            .PublishAsync(
                topic,
                new Notification2 { Farewell = $"Goodbye from topic2 {topic.Topic2Id}" },
                ctx.RequestAborted
            )

);

app.Run();
