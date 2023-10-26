using LeanCode.Logging;
using LeanCode.Pipe;
using LeanCode.Pipe.Funnel.FunnelledService;
using LeanCode.Pipe.Funnel.TestApp1;
using MassTransit;

var appBuilder = WebApplication.CreateBuilder(args);
var hostBuilder = appBuilder.Host;

hostBuilder.ConfigureDefaultLogging("TestApp1", new[] { typeof(Program).Assembly });

var services = appBuilder.Services;

services.AddFunnelledLeanPipe(new(typeof(Topic1)), new(typeof(Topic1Keys)));

services.AddOptions<MassTransitHostOptions>().Configure(opts => opts.WaitUntilStarted = true);
services.AddMassTransit(cfg =>
{
    cfg.AddFunnelledLeanPipeConsumers("TestApp1", new[] { typeof(Program).Assembly });

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

app.MapPost(
    "/publish",
    async (HttpContext ctx, Topic1 topic, ILeanPipePublisher<Topic1> publisher) =>
        await publisher.PublishAsync(
            topic,
            new Notification1 { Greeting = $"Hello from topic1 {topic.Topic1Id}" },
            ctx.RequestAborted
        )
);

app.Run();
