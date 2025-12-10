using FluentAssertions;
using LeanCode.Contracts;
using Xunit;

namespace LeanCode.Pipe.TestClient.Tests;

public class TopicDeepEqualityComparerTests
{
    private static readonly TopicDeepEqualityComparer ComparerInstance =
        TopicDeepEqualityComparer.Instance;

    private static ComplexTopic GetComplexTopic() =>
        new()
        {
            PrimitiveGuid = Guid.Parse("c00d2320-3ff8-4fcb-854f-8c53d8d2637f"),
            ListOfPrimitives = new() { 1, 2 },
            Complex = new() { PrimitiveString = "String1" },
        };

    [Fact]
    public void Topics_are_correctly_compared_when_they_are_the_same()
    {
        var topic1 = GetComplexTopic();
        var topic2 = GetComplexTopic();

        ComparerInstance.Equals(topic1, topic2).Should().BeTrue();

        ComparerInstance.GetHashCode(topic1).Should().Be(ComparerInstance.GetHashCode(topic2));
    }

    [Fact]
    public void Topics_are_correctly_compared_when_some_primitives_differ()
    {
        var topic1 = GetComplexTopic();
        var topic2 = GetComplexTopic();
        topic2.PrimitiveGuid = Guid.NewGuid();

        ComparerInstance.Equals(topic1, topic2).Should().BeFalse();

        ComparerInstance.GetHashCode(topic1).Should().NotBe(ComparerInstance.GetHashCode(topic2));
    }

    [Fact]
    public void Topics_are_correctly_compared_when_some_lists_differ()
    {
        var topic1 = GetComplexTopic();
        var topic2 = GetComplexTopic();
        topic2.ListOfPrimitives[^1] = 3;

        ComparerInstance.Equals(topic1, topic2).Should().BeFalse();

        ComparerInstance.GetHashCode(topic1).Should().NotBe(ComparerInstance.GetHashCode(topic2));

        var topic3 = GetComplexTopic();
        topic3.ListOfPrimitives.Add(3);

        ComparerInstance.Equals(topic1, topic3).Should().BeFalse();

        ComparerInstance.GetHashCode(topic1).Should().NotBe(ComparerInstance.GetHashCode(topic3));
    }

    [Fact]
    public void Topics_are_correctly_compared_when_some_complex_objects_differ()
    {
        var topic1 = GetComplexTopic();
        var topic2 = GetComplexTopic();
        topic2.Complex.PrimitiveString = "String2";

        ComparerInstance.Equals(topic1, topic2).Should().BeFalse();

        ComparerInstance.GetHashCode(topic1).Should().NotBe(ComparerInstance.GetHashCode(topic2));
    }

    private sealed class ComplexTopic : ITopic
    {
        public Guid PrimitiveGuid { get; set; }
        public List<int> ListOfPrimitives { get; set; } = default!;
        public ComplexDTO Complex { get; set; } = default!;
    }

    private sealed class ComplexDTO
    {
        public string PrimitiveString { get; set; } = default!;
    }
}
