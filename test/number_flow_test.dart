import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_number_flow/number_flow.dart';

void main() {
  group('NumberFlow Widget Tests', () {
    testWidgets('NumberFlow displays value correctly',
        (WidgetTester tester) async {
      const testValue = 123.45;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NumberFlow(
              value: testValue,
              format: NumberFlowFormat(
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
              ),
            ),
          ),
        ),
      );

      // Wait for initial render
      await tester.pumpAndSettle();

      // The NumberFlow should display the formatted number
      expect(find.text('123.45'), findsOneWidget);
    });

    testWidgets('NumberFlow animates value changes',
        (WidgetTester tester) async {
      double testValue = 100.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  NumberFlow(
                    value: testValue,
                    animationStyle: NumberFlowAnimation.slide,
                    duration: const Duration(milliseconds: 300),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => testValue = 200.0),
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initial value
      await tester.pumpAndSettle();

      // Tap update button
      await tester.tap(find.text('Update'));
      await tester.pump();

      // Animation should be in progress
      await tester.pump(const Duration(milliseconds: 150));

      // Complete animation
      await tester.pumpAndSettle();

      // Should now show updated value
      expect(find.text('200'), findsOneWidget);
    });

    test('NumberFlowFormat configuration', () {
      const format = NumberFlowFormat(
        prefix: r'$',
        suffix: ' USD',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
        notation: NumberNotation.standard,
      );

      expect(format.prefix, equals(r'$'));
      expect(format.suffix, equals(' USD'));
      expect(format.minimumFractionDigits, equals(2));
      expect(format.maximumFractionDigits, equals(2));
      expect(format.notation, equals(NumberNotation.standard));
    });

    test('NumberFlowAnimation enum values', () {
      expect(NumberFlowAnimation.values.length, equals(2));
      expect(NumberFlowAnimation.values, contains(NumberFlowAnimation.slide));
      expect(
        NumberFlowAnimation.values,
        contains(NumberFlowAnimation.crossFade),
      );
    });

    test('NumberNotation enum values', () {
      expect(NumberNotation.values.length, equals(2));
      expect(NumberNotation.values, contains(NumberNotation.standard));
      expect(NumberNotation.values, contains(NumberNotation.compact));
    });
  });

  group('NumberFormatter Tests', () {
    test('NumberFormatter initialization', () {
      const format = NumberFlowFormat();
      final formatter = NumberFormatter(format);

      expect(formatter.format, equals(format));
    });

    test('NumberFormatter basic formatting', () {
      const format = NumberFlowFormat();
      final formatter = NumberFormatter(format);
      formatter.initialize();

      // Basic number formatting
      final result = formatter.formatNumber(1234.56);
      expect(result, isA<String>());
      expect(result.isNotEmpty, true);
    });
  });
}
