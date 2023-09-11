using System.Collections;

namespace LeanPipe.TestClient;

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

        // Compare the types
        if (x.GetType() != y!.GetType())
        {
            return false;
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

        hashCode.Add(obj.GetType());

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
                var type = value!.GetType();

                // Values are primitive
                if (type.IsValueType || value is string)
                {
                    hashCode.Add(value);
                }
                else // Values are complex
                {
                    hashCode.AddBytes(BitConverter.GetBytes(GetHashCode(value)));
                }
            }
        }

        return hashCode.ToHashCode();
    }
}
