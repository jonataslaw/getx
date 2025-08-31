
import 'package:get/get_utils/src/equality/equality.dart';

/// A sealed class representing the status of an asynchronous operation.
///
/// This can be one of:
/// - [LoadingStatus]: The operation is in progress
/// - [SuccessStatus]: The operation completed successfully with data
/// - [ErrorStatus]: The operation failed with an error
/// - [EmptyStatus]: The operation completed but returned no data
/// - [CustomStatus]: A custom status for specialized use cases
sealed class GetStatus<T> with Equality {
  const GetStatus._(); // Private constructor for the sealed class

  // Factory constructors for each variant
  const factory GetStatus.loading() = LoadingStatus<T>._;
  const factory GetStatus.error([Object? error]) = ErrorStatus<T>._;
  const factory GetStatus.empty() = EmptyStatus<T>._;
  const factory GetStatus.success(T data) = SuccessStatus<T>._;
  const factory GetStatus.custom() = CustomStatus<T>._;

  /// Pattern matching helper method
  R match<R>({
    required R Function() loading,
    required R Function(Object? error) error,
    required R Function() empty,
    required R Function(T data) success,
    required R Function() custom,
  }) {
    return switch (this) {
      LoadingStatus() => loading(),
      ErrorStatus(error: var e) => error(e),
      EmptyStatus() => empty(),
      SuccessStatus(data: var d) => success(d),
      CustomStatus() => custom(),
    };
  }

  /// Returns the data if this is a [SuccessStatus], otherwise returns null
  T? get dataOrNull => switch (this) {
    SuccessStatus(data: var d) => d,
    _ => null,
  };

  /// Returns the error if this is an [ErrorStatus], otherwise returns null
  Object? get errorOrNull => switch (this) {
    ErrorStatus(error: var e) => e,
    _ => null,
  };

  /// Returns true if this is a [LoadingStatus]
  bool get isLoading => this is LoadingStatus<T>;

  /// Returns true if this is an [ErrorStatus]
  bool get isError => this is ErrorStatus<T>;

  /// Returns true if this is an [EmptyStatus]
  bool get isEmpty => this is EmptyStatus<T>;

  /// Returns true if this is a [SuccessStatus]
  bool get isSuccess => this is SuccessStatus<T>;

  /// Returns true if this is a [CustomStatus]
  bool get isCustom => this is CustomStatus<T>;
}

/// The operation is in progress
final class LoadingStatus<T> extends GetStatus<T> {
  const LoadingStatus._() : super._();

  @override
  List<Object?> get props => [];
}

/// The operation completed with an error
final class ErrorStatus<T> extends GetStatus<T> {
  final Object? error;
  const ErrorStatus._([this.error]) : super._();

  @override
  List<Object?> get props => [error];
}

/// The operation completed but returned no data
final class EmptyStatus<T> extends GetStatus<T> {
  const EmptyStatus._() : super._();

  @override
  List<Object?> get props => [];
}

/// The operation completed successfully with data
final class SuccessStatus<T> extends GetStatus<T> {
  final T data;
  const SuccessStatus._(this.data) : super._();

  @override
  List<Object?> get props => [data];
}

/// A custom status for specialized use cases
final class CustomStatus<T> extends GetStatus<T> {
  const CustomStatus._() : super._();

  @override
  List<Object?> get props => [];
}

/// Extension for additional functionality on GetStatus
extension GetStatusExt<T> on GetStatus<T> {
  /// Returns the data if this is a [SuccessStatus], otherwise returns [defaultValue]
  T dataOr(T defaultValue) => switch (this) {
    SuccessStatus(data: var d) => d,
    _ => defaultValue,
  };

  /// Transforms the data if this is a [SuccessStatus], otherwise returns the same status
  GetStatus<R> mapSuccess<R>(R Function(T) transform) => switch (this) {
    SuccessStatus(data: var d) => GetStatus.success(transform(d)),
    LoadingStatus() => GetStatus.loading(),
    ErrorStatus(error: var e) => GetStatus.error(e),
    EmptyStatus() => GetStatus.empty(),
    CustomStatus() => GetStatus.custom(),
  };

  /// Executes the appropriate callback based on the status and returns the result
  R when<R>({
    R Function()? loading,
    R Function(Object? error)? error,
    R Function()? empty,
    R Function(T data)? success,
    R Function()? custom,
  }) {
    return switch (this) {
      LoadingStatus() =>
        loading?.call() ?? (throw StateError('No handler for loading state')),
      ErrorStatus(error: var e) =>
        error?.call(e) ?? (throw StateError('No handler for error state')),
      EmptyStatus() =>
        empty?.call() ?? (throw StateError('No handler for empty state')),
      SuccessStatus(data: var d) =>
        success?.call(d) ?? (throw StateError('No handler for success state')),
      CustomStatus() =>
        custom?.call() ?? (throw StateError('No handler for custom state')),
    };
  }
}
