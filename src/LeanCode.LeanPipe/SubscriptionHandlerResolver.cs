using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.LeanPipe;

public interface ISubscriptionHandlerResolver<out TTopic>
{
    ISubscriptionHandlerWrapper FindSubscriptionHandler();
}

internal sealed class SubscriptionHandlerResolver<TTopic> : ISubscriptionHandlerResolver<TTopic>
{
    private static readonly Type TopicType = typeof(TTopic);
    private static readonly Type HandlerBase = typeof(ISubscriptionHandler<>);
    private static readonly Type HandlerWrapperBase = typeof(SubscriptionHandlerWrapper<>);
    private static readonly Type HandlerType = HandlerBase.MakeGenericType(new[] { TopicType });
    private static readonly Type WrapperType = HandlerWrapperBase.MakeGenericType(
        new[] { TopicType }
    );

    private readonly IServiceProvider services;

    public SubscriptionHandlerResolver(IServiceProvider services)
    {
        this.services = services;
    }

    public ISubscriptionHandlerWrapper FindSubscriptionHandler()
    {
        var handler = services.GetRequiredService(HandlerType);
        var wrapper =
            Activator.CreateInstance(WrapperType, new[] { handler })
            ?? throw new InvalidOperationException(
                $"Cannot create subscription handler wrapper instance of type {WrapperType}."
            );
        return (ISubscriptionHandlerWrapper)wrapper;
    }
}
