class Logger {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    print('** $text [$isError]');
  }
}
