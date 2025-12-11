using System.Collections.Concurrent;
using System.Reflection;

namespace LeanCode.Pipe;

public sealed class SubscriptionHandlerResolver
{
    private static readonly Type HandlerBase = typeof(ISubscriptionHandler<>);
    private static readonly Type HandlerWrapperBase = typeof(SubscriptionHandlerWrapper<>);

    private static readonly ConcurrentDictionary<
        Type,
        (Type HandlerType, ConstructorInfo Constructor)
    > cache = new();
    private readonly IServiceProvider services;

    public SubscriptionHandlerResolver(IServiceProvider services)
    {
        this.services = services;
    }

    public ISubscriptionHandlerWrapper? FindSubscriptionHandler(Type topicType)
    {
        var (handlerType, constructor) = cache.GetOrAdd(topicType, ResolveTypes);
        var handler = services.GetService(handlerType);
        if (handler is not null)
        {
            var wrapper = constructor.Invoke(new[] { handler });
            return (ISubscriptionHandlerWrapper)wrapper;
        }
        else
        {
            return null;
        }
    }

    private static (Type HandlerType, ConstructorInfo Constructor) ResolveTypes(Type topicType)
    {
        var handlerType = HandlerBase.MakeGenericType(topicType);
        var wrapperType = HandlerWrapperBase.MakeGenericType(topicType);
        var ctor = wrapperType.GetConstructors()[0];
        return (handlerType, ctor);
    }
}
