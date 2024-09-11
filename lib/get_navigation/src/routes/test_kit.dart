class GetTestMode {
  static bool active = false;
  static Object? _arguments;

  static void setTestArguments(Object? arguments) {
    _arguments = arguments;
  }

  static Object? get arguments => _arguments;

  static Map<String, String?> _parameters = {};

  static void setTestParameters(Map<String, String?> parameters) {
    _parameters = parameters;
  }

  static Map<String, String?> get parameters => _parameters;
}
