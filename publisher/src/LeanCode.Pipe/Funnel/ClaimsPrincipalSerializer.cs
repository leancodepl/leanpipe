using System.Security.Claims;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace LeanCode.Pipe.Funnel;

public class ClaimsPrincipalJsonConverter : JsonConverter<ClaimsPrincipal>
{
    public static ClaimsPrincipalJsonConverter Instance = new();

    public override ClaimsPrincipal? Read(
        ref Utf8JsonReader reader,
        Type typeToConvert,
        JsonSerializerOptions options
    )
    {
        var base64 = reader.GetString();

        if (base64 is null)
        {
            return null;
        }

        using var ms = new MemoryStream(Convert.FromBase64String(base64));
        using var binaryReader = new BinaryReader(ms);

        return new(binaryReader);
    }

    public override void Write(
        Utf8JsonWriter writer,
        ClaimsPrincipal value,
        JsonSerializerOptions options
    )
    {
        using var ms = new MemoryStream();
        using var binaryWriter = new BinaryWriter(ms);

        value.WriteTo(binaryWriter);
        writer.WriteStringValue(Convert.ToBase64String(ms.ToArray()));
    }
}
