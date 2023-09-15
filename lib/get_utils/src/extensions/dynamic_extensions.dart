import '../get_utils/get_utils.dart';

/// An extension on [dynamic] providing utility methods for common operations on dynamic objects.
extension GetDynamicUtilsExt on dynamic {
  /// Checks if the dynamic object is considered blank or empty.
  ///
  /// A dynamic object is considered blank if it is `null`, an empty string, an empty list,
  /// an empty map, or an empty iterable. It returns `true` if the object is blank; otherwise, `false`.
  ///
  /// Example usage:
  /// ```dart
  /// final emptyString = '';
  /// final nullValue = null;
  /// final nonEmptyList = [1, 2, 3];
  ///
  /// emptyString.isBlank; // Returns true
  /// nullValue.isBlank;   // Returns true
  /// nonEmptyList.isBlank; // Returns false
  /// ```
  bool? get isBlank => GetUtils.isBlank(this);

  /// Prints an error message with optional additional information.
  ///
  /// This method is used to log error messages, providing context to the error.
  ///
  /// Example usage:
  /// ```dart
  /// final errorMessage = 'Something went wrong!';
  /// final additionalInfo = 'Failed to load data';
  ///
  /// dynamicObject.printError(info: additionalInfo); // Logs an error message with additional information.
  /// ```
  ///
  /// The [logFunction] parameter allows customizing the logging function; by default, it uses [GetUtils.printFunction].
  void printError({
    String info = '',
    Function logFunction = GetUtils.printFunction,
  }) =>
      logFunction(
        'Error: $runtimeType',
        this,
        info,
        isError: true,
      );

  /// Prints an informational message with optional additional information.
  ///
  /// This method is used to log informational messages, providing context or updates.
  ///
  /// Example usage:
  /// ```dart
  /// final infoMessage = 'Data loaded successfully';
  /// final additionalInfo = 'Data count: 10';
  ///
  /// dynamicObject.printInfo(info: additionalInfo); // Logs an info message with additional information.
  /// ```
  ///
  /// The [printFunction] parameter allows customizing the printing function; by default, it uses [GetUtils.printFunction].
  void printInfo({
    String info = '',
    Function printFunction = GetUtils.printFunction,
  }) =>
      printFunction(
        'Info: $runtimeType',
        this,
        info,
      );
}
