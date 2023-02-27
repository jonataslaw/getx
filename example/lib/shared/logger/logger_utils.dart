mixin Logger {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    // ignore: avoid_print
    Future.microtask(() => print('** $text. isError: [$isError]'));
  }
}
