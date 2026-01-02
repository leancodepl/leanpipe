using System.Text.Json;
using LeanCode.Serialization;

namespace LeanCode.Pipe;

public static class LeanPipeJsonSerializerOptionsExtensions
{
    public static void ConfigureForCQRS(this JsonSerializerOptions options)
    {
        options.Converters.Add(new JsonLaxDateOnlyConverter());
        options.Converters.Add(new JsonLaxTimeOnlyConverter());
        options.Converters.Add(new JsonLaxDateTimeOffsetConverter());
        options.PropertyNamingPolicy = null;
    }
}
