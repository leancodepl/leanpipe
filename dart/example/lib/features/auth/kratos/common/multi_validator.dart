typedef FieldValidator<T> = String? Function(T? value);

class MultiValidator<T> {
  MultiValidator(this.validators);

  final List<FieldValidator<T>> validators;

  String? call(T? value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
