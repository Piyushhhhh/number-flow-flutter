import 'package:flutter_number_flow/flutter_number_flow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumberFlowFormat', () {
    test('has stable defaults', () {
      const format = NumberFlowFormat();

      expect(format.locale, isNull);
      expect(format.notation, NumberNotation.standard);
      expect(format.prefix, isNull);
      expect(format.suffix, isNull);
      expect(format.minimumFractionDigits, isNull);
      expect(format.maximumFractionDigits, isNull);
    });

    test('uses value equality', () {
      const first = NumberFlowFormat(
        locale: 'en_US',
        notation: NumberNotation.compact,
        prefix: r'$',
        suffix: ' USD',
        minimumFractionDigits: 1,
        maximumFractionDigits: 3,
      );
      const second = NumberFlowFormat(
        locale: 'en_US',
        notation: NumberNotation.compact,
        prefix: r'$',
        suffix: ' USD',
        minimumFractionDigits: 1,
        maximumFractionDigits: 3,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('rejects invalid fraction ranges', () {
      expect(
        () => NumberFlowFormat(minimumFractionDigits: -1),
        throwsAssertionError,
      );
      expect(
        () => NumberFlowFormat(
          minimumFractionDigits: 3,
          maximumFractionDigits: 2,
        ),
        throwsAssertionError,
      );
    });
  });

  group('NumberFormatter', () {
    test('lazily initializes with every configured option', () {
      final formatter = NumberFormatter(
        const NumberFlowFormat(
          locale: 'en_US',
          prefix: r'$',
          suffix: ' USD',
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        ),
      );

      expect(formatter.formatNumber(1234.5), r'$1,234.50 USD');
      expect(formatter.localeString, 'en_US');
    });

    test('supports locale-specific separators', () {
      final formatter = NumberFormatter(
        const NumberFlowFormat(
          locale: 'de_DE',
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        ),
      );

      expect(formatter.formatNumber(1234.5), '1.234,50');
      expect(formatter.localeString, 'de_DE');
    });

    test('supports compact notation', () {
      final formatter = NumberFormatter(
        const NumberFlowFormat(
          locale: 'en_US',
          notation: NumberNotation.compact,
          maximumFractionDigits: 1,
        ),
      );

      expect(formatter.formatNumber(1500000), '1.5M');
    });
  });
}
