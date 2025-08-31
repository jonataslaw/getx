import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_state_manager/src/rx_flutter/get_status.dart';
import 'package:get/state_manager.dart';

void main() {
  group('GetStatus Tests', () {
    test('LoadingStatus should be correctly instantiated', () {
      final status = GetStatus<int>.loading();
      expect(status, isA<LoadingStatus<int>>());
      expect(status.isLoading, isTrue);
      expect(status.isSuccess, isFalse);
      expect(status.isError, isFalse);
      expect(status.isEmpty, isFalse);
      expect(status.isCustom, isFalse);
    });

    test('SuccessStatus should contain correct data', () {
      const data = 42;
      final status = GetStatus<int>.success(data);
      
      expect(status, isA<SuccessStatus<int>>());
      expect(status.isSuccess, isTrue);
      expect(status.dataOrNull, equals(data));
      expect(status.errorOrNull, isNull);
      
      final successStatus = status as SuccessStatus<int>;
      expect(successStatus.data, equals(data));
    });

    test('ErrorStatus should contain error', () {
      final error = Exception('Test error');
      final status = GetStatus<int>.error(error);
      
      expect(status, isA<ErrorStatus<int>>());
      expect(status.isError, isTrue);
      expect(status.errorOrNull, equals(error));
      expect(status.dataOrNull, isNull);
    });

    test('EmptyStatus should be correctly instantiated', () {
      final status = GetStatus<int>.empty();
      
      expect(status, isA<EmptyStatus<int>>());
      expect(status.isEmpty, isTrue);
      expect(status.dataOrNull, isNull);
      expect(status.errorOrNull, isNull);
    });

    test('CustomStatus should be correctly instantiated', () {
      final status = GetStatus<int>.custom();
      
      expect(status, isA<CustomStatus<int>>());
      expect(status.isCustom, isTrue);
      expect(status.dataOrNull, isNull);
      expect(status.errorOrNull, isNull);
    });

    test('match should call correct callback based on status', () {
      // Test loading
      var status = GetStatus<int>.loading();
      var result = status.match(
        loading: () => 'loading',
        success: (_) => 'success',
        error: (_) => 'error',
        empty: () => 'empty',
        custom: () => 'custom',
      );
      expect(result, equals('loading'));

      // Test success
      status = GetStatus<int>.success(42);
      result = status.match(
        loading: () => 'loading',
        success: (data) => 'success:$data',
        error: (_) => 'error',
        empty: () => 'empty',
        custom: () => 'custom',
      );
      expect(result, equals('success:42'));

      // Test error
      final error = Exception('test');
      status = GetStatus<int>.error(error);
      result = status.match(
        loading: () => 'loading',
        success: (_) => 'success',
        error: (e) => 'error:${e?.toString()}',
        empty: () => 'empty',
        custom: () => 'custom',
      );
      expect(result, 'error:${error.toString()}');
    });

    test('dataOr should return data or default value', () {
      final success = GetStatus<int>.success(42);
      expect(success.dataOr(0), equals(42));
      
      final loading = GetStatus<int>.loading();
      expect(loading.dataOr(0), equals(0));
    });

    test('when should call correct callback', () {
      var called = '';
      final status = GetStatus<int>.success(42);
      
      status.when(
        success: (data) => called = 'success:$data',
        loading: () => called = 'loading',
        error: (_) => called = 'error',
        empty: () => called = 'empty',
        custom: () => called = 'custom',
      );
      
      expect(called, equals('success:42'));
    });

    test('mapSuccess should transform success data', () {
      final status = GetStatus<int>.success(21);
      final mapped = status.mapSuccess((data) => data * 2);
      
      expect(mapped, isA<SuccessStatus<int>>());
      expect((mapped as SuccessStatus).data, equals(42));
      
      // Test with non-success status
      final loading = GetStatus<int>.loading();
      final mappedLoading = loading.mapSuccess((data) => data * 2);
      expect(mappedLoading, isA<LoadingStatus<int>>());
    });
  });

  group('StateMixin Tests', () {
    test('setSuccess should update status and value', () {
      final controller = TestController();
      controller.setSuccess(42);
      
      expect(controller.status.isSuccess, isTrue);
      expect(controller.status.dataOrNull, equals(42));
      expect(controller.testValue, equals(42));
    });

    test('setError should update status with error', () {
      final controller = TestController();
      final error = Exception('Test error');
      controller.setError(error);
      
      expect(controller.status.isError, isTrue);
      expect(controller.status.errorOrNull, equals(error));
    });

    test('setLoading should update status to loading', () {
      final controller = TestController();
      controller.setLoading();
      
      expect(controller.status.isLoading, isTrue);
    });

    test('setEmpty should update status to empty', () {
      final controller = TestController();
      controller.setEmpty();
      
      expect(controller.status.isEmpty, isTrue);
    });

    test('futurize should handle success case', () async {
      final controller = TestController();
      final future = controller.futurize(() => Future.value(42));
      
      expect(controller.status.isLoading, isTrue);
      final result = await future;
      
      expect(result, equals(42));
      expect(controller.status.isSuccess, isTrue);
      expect(controller.testValue, equals(42));
    });

    test('futurize should handle error case', () async {
      final controller = TestController();
      final error = Exception('Test error');
      
      try {
        await controller.futurize(
          () => Future.error(error),
          errorMessage: 'Custom error',
        );
        fail('Should throw an error');
      } catch (e) {
        expect(controller.status.isError, isTrue);
        expect(
          controller.status.errorOrNull.toString(), 
          'Exception: Custom error: Exception: Test error',
        );
      }
    });
  });
}

// Test controller that uses StateMixin
class TestController extends GetxController with StateMixin<int> {
  // Public getter to access the protected value for testing
  int get testValue => value;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize with loading state
    setLoading();
  }
}
