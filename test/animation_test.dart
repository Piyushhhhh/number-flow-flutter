import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_number_flow/number_flow.dart';

void main() {
  group('Animation Tests', () {
    testWidgets('NumberFlow slide animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NumberFlow(
              value: 123,
              animationStyle: NumberFlowAnimation.slide,
              duration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(NumberFlow), findsOneWidget);
    });

    testWidgets('NumberFlow crossFade animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NumberFlow(
              value: 456,
              animationStyle: NumberFlowAnimation.crossFade,
              duration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(NumberFlow), findsOneWidget);
    });

    testWidgets('NumberFlow with custom animation curve',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NumberFlow(
              value: 789,
              curve: Curves.bounceIn,
              duration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(NumberFlow), findsOneWidget);
    });

    testWidgets('NumberFlow with custom text style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NumberFlow(
              value: 101112,
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(NumberFlow), findsOneWidget);
    });

    test('NumberFlowAnimation enum values', () {
      expect(NumberFlowAnimation.slide, isA<NumberFlowAnimation>());
      expect(NumberFlowAnimation.crossFade, isA<NumberFlowAnimation>());

      // Ensure we have exactly 2 animation types
      expect(NumberFlowAnimation.values.length, equals(2));
    });

    testWidgets('NumberFlow animation duration configuration',
        (WidgetTester tester) async {
      const shortDuration = Duration(milliseconds: 100);
      const longDuration = Duration(milliseconds: 1000);

      // Test short duration
      await tester.pumpWidget(
        const MaterialApp(
          home: NumberFlow(
            value: 111,
            duration: shortDuration,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Test long duration
      await tester.pumpWidget(
        const MaterialApp(
          home: NumberFlow(
            value: 222,
            duration: longDuration,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NumberFlow), findsOneWidget);
    });
  });
}
