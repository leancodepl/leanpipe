Future<void> wait({
  int seconds = 0,
  int milliseconds = 0,
}) =>
    Future<void>.delayed(
      Duration(seconds: seconds, milliseconds: milliseconds),
    );
