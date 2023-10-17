using FluentAssertions;
using Xunit;

namespace LeanCode.Pipe.Tests;

public class SubscriptionHandlerWrapperTests
{
    [Fact]
    public async Task Proxies_the_call_to_OnSubscribedAsync()
    {
        var handler = new StubHandler();
        var wrapper = new SubscriptionHandlerWrapper<Topic1>(handler);

        await wrapper.OnSubscribedAsync(new Topic1(), null!, null!, default);

        handler.SubscribedCalled.Should().BeTrue();
    }

    [Fact]
    public async Task Proxies_the_call_to_OnUnsubscribedAsync()
    {
        var handler = new StubHandler();
        var wrapper = new SubscriptionHandlerWrapper<Topic1>(handler);

        await wrapper.OnUnsubscribedAsync(new Topic1(), null!, null!, default);

        handler.UnsubscribedCalled.Should().BeTrue();
    }

    [Fact]
    public void The_type_has_only_a_single_ctor_that_accepts_handler()
    {
        var type = typeof(SubscriptionHandlerWrapper<Topic1>);

        type.GetConstructors()
            .Should()
            .ContainSingle()
            .Which.GetParameters()
            .Should()
            .ContainSingle()
            .Which.ParameterType.Should()
            .Be(typeof(ISubscriptionHandler<Topic1>));
    }
}
