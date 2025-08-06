/// Character-level difference calculation for efficient number animations
class CharacterDiff {
  const CharacterDiff({
    required this.index,
    required this.oldChar,
    required this.newChar,
    required this.changeType,
  });

  /// Position of the character in the string
  final int index;

  /// Previous character (null for insertions)
  final String? oldChar;

  /// New character (null for deletions)
  final String? newChar;

  /// Type of change at this position
  final DiffType changeType;
}

/// Types of character-level changes
enum DiffType {
  /// Character remains the same
  unchanged,

  /// Character was modified
  modified,

  /// Character was inserted
  inserted,

  /// Character was deleted
  deleted,
}

/// Calculates character-level differences between two strings
class StringDiffer {
  /// Calculate minimal character differences between old and new strings
  ///
  /// Uses an optimized algorithm that works well for number strings.
  /// Identifies unchanged prefix/suffix and handles the changing middle section.
  static List<CharacterDiff> calculateDiff(String oldString, String newString) {
    final List<CharacterDiff> diffs = [];

    // Handle empty strings
    if (oldString.isEmpty && newString.isEmpty) {
      return diffs;
    }

    if (oldString.isEmpty) {
      for (int i = 0; i < newString.length; i++) {
        diffs.add(
          CharacterDiff(
            index: i,
            oldChar: null,
            newChar: newString[i],
            changeType: DiffType.inserted,
          ),
        );
      }
      return diffs;
    }

    if (newString.isEmpty) {
      for (int i = 0; i < oldString.length; i++) {
        diffs.add(
          CharacterDiff(
            index: i,
            oldChar: oldString[i],
            newChar: null,
            changeType: DiffType.deleted,
          ),
        );
      }
      return diffs;
    }

    // Find common prefix
    int prefixLength = 0;
    final minLength = oldString.length < newString.length
        ? oldString.length
        : newString.length;
    while (prefixLength < minLength &&
        oldString[prefixLength] == newString[prefixLength]) {
      prefixLength++;
    }

    // Find common suffix
    int suffixLength = 0;
    final int oldEnd = oldString.length - 1;
    final int newEnd = newString.length - 1;
    while (suffixLength < minLength - prefixLength &&
        oldString[oldEnd - suffixLength] == newString[newEnd - suffixLength]) {
      suffixLength++;
    }

    // Add unchanged prefix
    for (int i = 0; i < prefixLength; i++) {
      diffs.add(
        CharacterDiff(
          index: i,
          oldChar: oldString[i],
          newChar: newString[i],
          changeType: DiffType.unchanged,
        ),
      );
    }

    // Calculate the changing middle section
    final oldMiddleStart = prefixLength;
    final oldMiddleEnd = oldString.length - suffixLength;
    final newMiddleStart = prefixLength;
    final newMiddleEnd = newString.length - suffixLength;

    final oldMiddle = oldString.substring(oldMiddleStart, oldMiddleEnd);
    final newMiddle = newString.substring(newMiddleStart, newMiddleEnd);

    // Handle the middle section
    _addMiddleDiffs(diffs, oldMiddle, newMiddle, prefixLength);

    // Add unchanged suffix
    for (int i = 0; i < suffixLength; i++) {
      final oldIndex = oldString.length - suffixLength + i;
      final newIndex = newString.length - suffixLength + i;
      diffs.add(
        CharacterDiff(
          index: newIndex,
          oldChar: oldString[oldIndex],
          newChar: newString[newIndex],
          changeType: DiffType.unchanged,
        ),
      );
    }

    return diffs;
  }

  /// Add diffs for the changing middle section
  static void _addMiddleDiffs(List<CharacterDiff> diffs, String oldMiddle,
      String newMiddle, int offset) {
    final maxLength = oldMiddle.length > newMiddle.length
        ? oldMiddle.length
        : newMiddle.length;

    for (int i = 0; i < maxLength; i++) {
      final oldChar = i < oldMiddle.length ? oldMiddle[i] : null;
      final newChar = i < newMiddle.length ? newMiddle[i] : null;

      if (oldChar == null) {
        diffs.add(
          CharacterDiff(
            index: offset + i,
            oldChar: null,
            newChar: newChar,
            changeType: DiffType.inserted,
          ),
        );
      } else if (newChar == null) {
        diffs.add(
          CharacterDiff(
            index: offset + i,
            oldChar: oldChar,
            newChar: null,
            changeType: DiffType.deleted,
          ),
        );
      } else if (oldChar == newChar) {
        diffs.add(
          CharacterDiff(
            index: offset + i,
            oldChar: oldChar,
            newChar: newChar,
            changeType: DiffType.unchanged,
          ),
        );
      } else {
        diffs.add(
          CharacterDiff(
            index: offset + i,
            oldChar: oldChar,
            newChar: newChar,
            changeType: DiffType.modified,
          ),
        );
      }
    }
  }
}
