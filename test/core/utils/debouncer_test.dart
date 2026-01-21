import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/core/utils/debouncer.dart';

void main() {
  late Debouncer debouncer;

  setUp(() {
    debouncer = Debouncer(milliseconds: 100);
  });

  tearDown(() {
    debouncer.dispose();
  });

  group('Debouncer', () {
    test('delays execution of action', () async {
      bool actionExecuted = false;

      debouncer.run(() {
        actionExecuted = true;
      });

      // Action should not have executed yet
      expect(actionExecuted, false);

      // Wait for the debounce delay
      await Future.delayed(const Duration(milliseconds: 150));

      // Action should now have executed
      expect(actionExecuted, true);
    });

    test('cancels previous action when run is called again', () async {
      int executionCount = 0;

      // First call
      debouncer.run(() {
        executionCount++;
      });

      // Second call before first completes
      await Future.delayed(const Duration(milliseconds: 50));
      debouncer.run(() {
        executionCount++;
      });

      // Wait for second delay
      await Future.delayed(const Duration(milliseconds: 150));

      // Only second action should have executed
      expect(executionCount, 1);
    });

    test('dispose cancels pending action', () async {
      bool actionExecuted = false;

      debouncer.run(() {
        actionExecuted = true;
      });

      // Dispose before action executes
      await Future.delayed(const Duration(milliseconds: 50));
      debouncer.dispose();

      // Wait to ensure action would have executed if not cancelled
      await Future.delayed(const Duration(milliseconds: 100));

      // Action should not have executed
      expect(actionExecuted, false);
    });
  });
}
