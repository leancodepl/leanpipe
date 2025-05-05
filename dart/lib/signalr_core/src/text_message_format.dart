mixin TextMessageFormat {
  static const recordSeparatorCode = 0x1e;

  static String recordSeparator =
      String.fromCharCode(TextMessageFormat.recordSeparatorCode);

  static String write(String output) {
    return '$output${TextMessageFormat.recordSeparator}';
  }

  static List<String> parse(String input) {
    if (input.isEmpty) {
      throw Exception('Message is incomplete.');
    }

    if (input[input.length - 1] != TextMessageFormat.recordSeparator) {
      throw Exception('Message is incomplete.');
    }

    var messages = input.split(TextMessageFormat.recordSeparator)..removeLast();
    return messages;
  }
}
