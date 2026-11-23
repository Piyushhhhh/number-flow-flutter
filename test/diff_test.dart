import 'package:flutter_number_flow/src/core/diff.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringDiffer', () {
    test('preserves a common prefix and suffix', () {
      final diffs = StringDiffer.calculateDiff(r'$12.40', r'$18.40');

      expect(diffs.map((diff) => diff.newChar).join(), r'$18.40');
      expect(diffs[0].changeType, DiffType.unchanged);
      expect(diffs[2].changeType, DiffType.modified);
      expect(diffs.last.changeType, DiffType.unchanged);
    });

    test('reports removed glyphs', () {
      final diffs = StringDiffer.calculateDiff(r'$1,993.41', r'$0.00');

      expect(
        diffs.where((diff) => diff.changeType == DiffType.deleted).length,
        4,
      );
      expect(
        diffs
            .where((diff) => diff.newChar != null)
            .map((diff) => diff.newChar)
            .join(),
        r'$0.00',
      );
    });

    test('treats a grapheme cluster as one glyph', () {
      final diffs = StringDiffer.calculateDiff('1 👩🏽‍💻', '2 👩🏽‍💻');

      expect(diffs, hasLength(3));
      expect(diffs.last.oldChar, '👩🏽‍💻');
      expect(diffs.last.changeType, DiffType.unchanged);
    });
  });
}
