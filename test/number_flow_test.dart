import 'package:flutter/material.dart';
import 'package:flutter_number_flow/flutter_number_flow.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _flowApp({
  required num value,
  num? previousValue,
  Key? key,
  NumberFlowAnimation style = NumberFlowAnimation.slide,
  NumberFlowFormat? format,
  double? scrubProgress,
  Duration duration = const Duration(milliseconds: 100),
  Curve curve = Curves.linear,
}) =>
    MaterialApp(
      home: Scaffold(
        body: NumberFlow(
          key: key,
          value: value,
          previousValue: previousValue,
          animationStyle: style,
          format: format,
          scrubProgress: scrubProgress,
          duration: duration,
          curve: curve,
          enableMask: false,
        ),
      ),
    );

double _glyphRowWidth(WidgetTester tester) {
  final row = find.descendant(
    of: find.byType(NumberFlow),
    matching: find.byType(Row),
  );
  return tester.getSize(row).width;
}

List<double> _opacities(WidgetTester tester, Finder parent) => tester
    .widgetList<Opacity>(
      find.descendant(of: parent, matching: find.byType(Opacity)),
    )
    .map((widget) => widget.opacity)
    .toList(growable: false);

class _GroupHarness extends StatefulWidget {
  const _GroupHarness({super.key});

  @override
  State<_GroupHarness> createState() => _GroupHarnessState();
}

class _GroupHarnessState extends State<_GroupHarness> {
  int first = 1;
  int second = 3;

  void updateBoth() {
    setState(() {
      first = 2;
      second = 4;
    });
  }

  void updateFirst() {
    setState(() => first = 5);
  }

  @override
  Widget build(BuildContext context) => NumberFlowGroupProvider(
        groupKey: 'group',
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
        child: Column(
          children: [
            NumberFlow(
              key: const Key('first'),
              value: first,
              groupKey: 'group',
              animationStyle: NumberFlowAnimation.crossFade,
              enableMask: false,
            ),
            NumberFlow(
              key: const Key('second'),
              value: second,
              groupKey: 'group',
              animationStyle: NumberFlowAnimation.crossFade,
              enableMask: false,
            ),
          ],
        ),
      );
}

void main() {
  testWidgets('exposes the complete formatted value to semantics',
      (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      _flowApp(
        value: 123.45,
        format: const NumberFlowFormat(
          prefix: r'$',
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        ),
      ),
    );

    expect(find.bySemanticsLabel(r'$123.45'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('automatically animates to a changed value', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      _flowApp(key: key, value: 100, style: NumberFlowAnimation.crossFade),
    );
    await tester.pumpWidget(
      _flowApp(key: key, value: 200, style: NumberFlowAnimation.crossFade),
    );

    await tester.pump(const Duration(milliseconds: 50));
    expect(_opacities(tester, find.byType(NumberFlow)), [0.5, 0.5]);

    await tester.pumpAndSettle();
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('200'), findsOneWidget);
    semantics.dispose();
  });

  for (final style in NumberFlowAnimation.values) {
    testWidgets('removed glyphs leave no width behind with $style',
        (tester) async {
      const format = NumberFlowFormat(
        prefix: r'$',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      );
      final key = GlobalKey();

      await tester.pumpWidget(
        _flowApp(key: key, value: 1993.41, style: style, format: format),
      );
      await tester.pumpWidget(
        _flowApp(key: key, value: 0, style: style, format: format),
      );
      await tester.pumpAndSettle();
      final shrunkWidth = _glyphRowWidth(tester);

      await tester.pumpWidget(
        _flowApp(
          key: UniqueKey(),
          value: 0,
          style: style,
          format: format,
        ),
      );

      expect(shrunkWidth, closeTo(_glyphRowWidth(tester), 0.001));
    });
  }

  testWidgets('inserted glyphs grow into the row', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(_flowApp(key: key, value: 9));
    final oldWidth = _glyphRowWidth(tester);

    await tester.pumpWidget(_flowApp(key: key, value: 100));
    await tester.pump(const Duration(milliseconds: 50));
    final middleWidth = _glyphRowWidth(tester);
    await tester.pumpAndSettle();
    final finalWidth = _glyphRowWidth(tester);

    expect(middleWidth, greaterThan(oldWidth));
    expect(middleWidth, lessThan(finalWidth));
  });

  testWidgets('scrubProgress directly controls a transition', (tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      _flowApp(
        key: key,
        value: 2,
        previousValue: 1,
        style: NumberFlowAnimation.crossFade,
        scrubProgress: 0,
      ),
    );
    expect(_opacities(tester, find.byType(NumberFlow)), [1, 0]);

    await tester.pumpWidget(
      _flowApp(
        key: key,
        value: 2,
        previousValue: 1,
        style: NumberFlowAnimation.crossFade,
        scrubProgress: 0.5,
      ),
    );
    expect(_opacities(tester, find.byType(NumberFlow)), [0.5, 0.5]);

    await tester.pumpWidget(
      _flowApp(
        key: key,
        value: 2,
        previousValue: 1,
        style: NumberFlowAnimation.crossFade,
        scrubProgress: 1,
      ),
    );
    expect(_opacities(tester, find.byType(NumberFlow)), [0, 1]);
  });

  testWidgets('previousValue animates on the first build', (tester) async {
    await tester.pumpWidget(
      _flowApp(
        value: 2,
        previousValue: 1,
        style: NumberFlowAnimation.crossFade,
      ),
    );
    await tester.pump();
    expect(_opacities(tester, find.byType(NumberFlow)), [1, 0]);

    await tester.pump(const Duration(milliseconds: 50));
    expect(_opacities(tester, find.byType(NumberFlow)), [0.5, 0.5]);

    await tester.pumpAndSettle();
    expect(_opacities(tester, find.byType(NumberFlow)), isEmpty);
  });

  testWidgets('grouped widgets share progress and do not replay stale diffs',
      (tester) async {
    final harnessKey = GlobalKey<_GroupHarnessState>();

    await tester.pumpWidget(
      MaterialApp(
        home: _GroupHarness(key: harnessKey),
      ),
    );

    harnessKey.currentState!.updateBoth();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(_opacities(tester, find.byKey(const Key('first'))), [0.5, 0.5]);
    expect(_opacities(tester, find.byKey(const Key('second'))), [0.5, 0.5]);
    await tester.pumpAndSettle();

    harnessKey.currentState!.updateFirst();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(_opacities(tester, find.byKey(const Key('first'))), [0.5, 0.5]);
    expect(_opacities(tester, find.byKey(const Key('second'))), isEmpty);
  });
}
