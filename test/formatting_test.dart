import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_number_flow/number_flow.dart';

void main() {
  group('Number Formatting Tests', () {
    test('NumberFlowFormat default values', () {
      const format = NumberFlowFormat();

      expect(format.locale, isNull);
      expect(format.notation, equals(NumberNotation.standard));
      expect(format.prefix, isNull);
      expect(format.suffix, isNull);
      expect(format.minimumFractionDigits, isNull);
      expect(format.maximumFractionDigits, isNull);
    });

    test('NumberFlowFormat with custom values', () {
      const format = NumberFlowFormat(
        locale: 'en_US',
        notation: NumberNotation.compact,
        prefix: r'$',
        suffix: ' USD',
        minimumFractionDigits: 1,
        maximumFractionDigits: 3,
      );

      expect(format.locale, equals('en_US'));
      expect(format.notation, equals(NumberNotation.compact));
      expect(format.prefix, equals(r'$'));
      expect(format.suffix, equals(' USD'));
      expect(format.minimumFractionDigits, equals(1));
      expect(format.maximumFractionDigits, equals(3));
    });

    test('NumberFormatter with different formats', () {
      // Standard format
      const standardFormat = NumberFlowFormat(
        notation: NumberNotation.standard,
        minimumFractionDigits: 2,
      );
      final standardFormatter = NumberFormatter(standardFormat);
      standardFormatter.initialize();

      expect(standardFormatter.format, equals(standardFormat));

      // Compact format
      const compactFormat = NumberFlowFormat(
        notation: NumberNotation.compact,
        maximumFractionDigits: 1,
      );
      final compactFormatter = NumberFormatter(compactFormat);
      compactFormatter.initialize();

      expect(compactFormatter.format, equals(compactFormat));
    });

    test('NumberFormatter basic number formatting', () {
      const format = NumberFlowFormat();
      final formatter = NumberFormatter(format);
      formatter.initialize();

      // Test various number types
      expect(formatter.formatNumber(0), isA<String>());
      expect(formatter.formatNumber(123), isA<String>());
      expect(formatter.formatNumber(123.45), isA<String>());
      expect(formatter.formatNumber(-123.45), isA<String>());
      expect(formatter.formatNumber(1000000), isA<String>());
    });

    test('NumberNotation enum', () {
      expect(NumberNotation.standard.toString(), contains('standard'));
      expect(NumberNotation.compact.toString(), contains('compact'));
    });
  });
}
