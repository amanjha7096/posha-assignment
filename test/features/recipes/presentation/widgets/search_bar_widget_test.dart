import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recipe/core/constants/colors.dart';
import 'package:recipe/features/recipes/presentation/widgets/search_bar_widget.dart';
import 'package:recipe/l10n/app_localizations.dart';

void main() {
  late TextEditingController controller;
  late List<String> searchCalls;

  setUp(() {
    controller = TextEditingController();
    searchCalls = [];
  });

  tearDown(() {
    controller.dispose();
  });

  Widget buildTestWidget({
    required TextEditingController controller,
    required Function(String) onSearch,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SearchBarWidget(
          controller: controller,
          onSearch: onSearch,
        ),
      ),
    );
  }

  group('SearchBarWidget', () {
    testWidgets('renders TextField with correct properties', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        controller: controller,
        onSearch: (query) => searchCalls.add(query),
      ));

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.controller, controller);
      expect(textFieldWidget.decoration?.hintText, 'Search recipe'); // This should now be localized
      expect(textFieldWidget.decoration?.prefixIcon, isA<Icon>());
      expect((textFieldWidget.decoration?.prefixIcon as Icon).icon, Icons.search);
      expect(textFieldWidget.decoration?.filled, true);
      expect(textFieldWidget.decoration?.fillColor, AppColors.white);
    });

    testWidgets('calls onSearch with debouncing after text input', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        controller: controller,
        onSearch: (query) => searchCalls.add(query),
      ));

      final textField = find.byType(TextField);

      // Enter text
      await tester.enterText(textField, 'test query');
      expect(searchCalls, isEmpty); // Should not call immediately due to debouncing

      // Wait for debounce delay (500ms) + a bit more
      await tester.pump(const Duration(milliseconds: 600));

      expect(searchCalls, ['test query']);
    });

    testWidgets('debounces multiple rapid inputs', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        controller: controller,
        onSearch: (query) => searchCalls.add(query),
      ));

      final textField = find.byType(TextField);

      // Enter text multiple times quickly
      await tester.enterText(textField, 'first');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(textField, 'second');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(textField, 'third');

      // Should not have called yet
      expect(searchCalls, isEmpty);

      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 500));

      // Should only call once with the last value
      expect(searchCalls, ['third']);
    });

    testWidgets('calls onSearch with empty string when text is cleared', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        controller: controller,
        onSearch: (query) => searchCalls.add(query),
      ));

      final textField = find.byType(TextField);

      // Enter and then clear text
      await tester.enterText(textField, 'query');
      await tester.pump(const Duration(milliseconds: 600));
      expect(searchCalls, ['query']);

      await tester.enterText(textField, '');
      await tester.pump(const Duration(milliseconds: 600));

      expect(searchCalls, ['query', '']);
    });

    testWidgets('disposes debouncer when widget is disposed', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        controller: controller,
        onSearch: (query) => searchCalls.add(query),
      ));

      final textField = find.byType(TextField);

      // Enter text but don't wait for debounce
      await tester.enterText(textField, 'test');

      // Dispose the widget
      await tester.pumpWidget(const SizedBox());

      // The debouncer should be disposed, so even after waiting, onSearch shouldn't be called
      await tester.pump(const Duration(milliseconds: 600));

      expect(searchCalls, isEmpty);
    });
  });
}
