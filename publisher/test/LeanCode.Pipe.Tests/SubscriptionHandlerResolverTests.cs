using LeanCode.Contracts;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Tests;

public class SubscriptionHandlerResolverTests
{
    [Fact]
    public async Task Resolves_wrapper_that_forwards_to_the_handler()
    {
        var handler = new StubHandler();
        var resolver = Prepare(handler);
        var wrapper = resolver.FindSubscriptionHandler(typeof(Topic1));

        wrapper.Should().NotBeNull();

        await wrapper!.OnSubscribedAsync(
            new Topic1(),
            null!,
            null!,
            TestContext.Current.CancellationToken
        );
        await wrapper.OnUnsubscribedAsync(
            new Topic1(),
            null!,
            null!,
            TestContext.Current.CancellationToken
        );

        handler.SubscribedCalled.Should().BeTrue();
        handler.UnsubscribedCalled.Should().BeTrue();
    }

    [Fact]
    public void Resolving_handler_for_the_same_subscription_twice_resolves_different_instances()
    {
        var resolver = Prepare(new StubHandler());

        var wrapper1 = resolver.FindSubscriptionHandler(typeof(Topic1));
        var wrapper2 = resolver.FindSubscriptionHandler(typeof(Topic1));

        wrapper1.Should().NotBeNull();
        wrapper2.Should().NotBeNull().And.NotBe(wrapper1);
    }

    [Fact]
    public async Task Resolvers_correct_handlers_for_different_topics()
    {
        var handler1 = new StubHandler<Topic1>();
        var handler2 = new StubHandler<Topic2>();

        var resolver = Prepare(handler1, handler2);

        var wrapper1 = resolver.FindSubscriptionHandler(typeof(Topic1));
        var wrapper2 = resolver.FindSubscriptionHandler(typeof(Topic2));

        await wrapper1!.OnSubscribedAsync(
            new Topic1(),
            null!,
            null!,
            TestContext.Current.CancellationToken
        );
        handler1.SubscribedCalled.Should().BeTrue();
        handler2.SubscribedCalled.Should().BeFalse();

        await wrapper2!.OnSubscribedAsync(
            new Topic2(),
            null!,
            null!,
            TestContext.Current.CancellationToken
        );
        handler1.SubscribedCalled.Should().BeTrue();
        handler2.SubscribedCalled.Should().BeTrue();
    }

    private static SubscriptionHandlerResolver Prepare<T1>(ISubscriptionHandler<T1> handler)
        where T1 : ITopic
    {
        var collection = new ServiceCollection();
        collection.AddSingleton(handler);
        collection.AddSingleton<SubscriptionHandlerResolver>();
        return collection.BuildServiceProvider().GetRequiredService<SubscriptionHandlerResolver>();
    }

    private static SubscriptionHandlerResolver Prepare<T1, T2>(
        ISubscriptionHandler<T1> handler1,
        ISubscriptionHandler<T2> handler2
    )
        where T1 : ITopic
        where T2 : ITopic
    {
        var collection = new ServiceCollection();
        collection.AddSingleton(handler1);
        collection.AddSingleton(handler2);
        collection.AddSingleton<SubscriptionHandlerResolver>();
        return collection.BuildServiceProvider().GetRequiredService<SubscriptionHandlerResolver>();
    }
}
