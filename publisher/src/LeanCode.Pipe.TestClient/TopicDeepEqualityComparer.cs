using System.Collections;

namespace LeanCode.Pipe.TestClient;

// Based on https://gist.github.com/danielkillyevo/5443439
internal class TopicDeepEqualityComparer : EqualityComparer<object>
{
    internal static readonly TopicDeepEqualityComparer Instance = new();

    public override bool Equals(object? x, object? y)
    {
        // Compare the references
        if (ReferenceEquals(x, y))
        {
            return true;
        }

        if (ReferenceEquals(x, null))
        {
            return false;
        }

        var xType = x.GetType();

        // Compare the types
        if (xType != y!.GetType())
        {
            return false;
        }

        if (IsPrimitive(xType))
        {
            if (x is string xString)
            {
                return string.Equals(xString, y as string, StringComparison.InvariantCulture);
            }
            else
            {
                return x.Equals(y);
            }
        }

        // Get all property infos of the right object
        var propertyInfos = x.GetType().GetProperties();

        // Compare the property values of the left and right object
        foreach (var propertyInfo in propertyInfos)
        {
            var othersValue = propertyInfo.GetValue(x);
            var currentsValue = propertyInfo.GetValue(y);

            if (othersValue == null && currentsValue == null)
            {
                continue;
            }

            // Comparison if the property is a generic (IList type)
            if (currentsValue is IList currentsList && propertyInfo.PropertyType.IsGenericType)
            {
                if (!(othersValue is IList othersList && propertyInfo.PropertyType.IsGenericType))
                {
                    return false;
                }

                if (currentsList.Count != othersList.Count)
                {
                    return false;
                }

                for (var i = 0; i < currentsList.Count; i++)
                {
                    if (!Equals(currentsList[i], othersList[i]))
                    {
                        return false;
                    }
                }
            }
            else
            {
                // Comparison for properties of a non collection type
                var curType = currentsValue?.GetType();

                if (curType is null)
                {
                    return false;
                }
                // Comparison for non-string primitive types
                else if (curType.IsValueType)
                {
                    if (!currentsValue!.Equals(othersValue))
                    {
                        return false;
                    }
                }
                else if (currentsValue is string currentsString)
                {
                    if (
                        !string.Equals(
                            currentsString,
                            othersValue as string,
                            StringComparison.InvariantCulture
                        )
                    )
                    {
                        return false;
                    }
                }
                else // Values are complex
                {
                    if (!Equals(currentsValue, othersValue))
                    {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    public override int GetHashCode(object obj)
    {
        var hashCode = new HashCode();

        var type = obj.GetType();

        hashCode.Add(type);

        if (IsPrimitive(type))
        {
            hashCode.Add(obj);
        }
        else
        {
            foreach (var propertyInfo in obj.GetType().GetProperties())
            {
                var value = propertyInfo.GetValue(obj);

                if (value is IList valueList && propertyInfo.PropertyType.IsGenericType)
                {
                    foreach (var listValue in valueList)
                    {
                        hashCode.AddBytes(BitConverter.GetBytes(GetHashCode(listValue)));
                    }
                }
                else
                {
                    if (IsPrimitive(value!.GetType()))
                    {
                        hashCode.Add(value);
                    }
                    else // Values are complex
                    {
                        hashCode.AddBytes(BitConverter.GetBytes(GetHashCode(value)));
                    }
                }
            }
        }

        return hashCode.ToHashCode();
    }

    private static bool IsPrimitive(Type type) => type.IsValueType || type == typeof(string);
}
