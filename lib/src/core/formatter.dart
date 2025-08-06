import 'package:intl/intl.dart';
import '../../number_flow.dart';

/// Configuration for number formatting
/// Configuration class for formatting numbers in [NumberFlow] widgets.
///
/// This class provides comprehensive options for formatting numbers including
/// locale support, decimal places, prefixes/suffixes, and compact notation.
///
/// Example usage:
/// ```dart
/// // Currency formatting
/// const NumberFlowFormat(
///   prefix: '\$',
///   minimumFractionDigits: 2,
///   maximumFractionDigits: 2,
/// )
///
/// // Compact notation
/// const NumberFlowFormat(
///   notation: NumberNotation.compact,
///   maximumFractionDigits: 1,
/// )
///
/// // Locale-specific formatting
/// const NumberFlowFormat(
///   locale: 'de_DE',
///   minimumFractionDigits: 2,
/// )
/// ```
///
/// The formatter uses the `intl` package internally for locale-aware formatting
/// and supports all standard number formatting options.
class NumberFlowFormat {
  const NumberFlowFormat({
    this.locale,
    this.notation = NumberNotation.standard,
    this.prefix,
    this.suffix,
    this.minimumFractionDigits,
    this.maximumFractionDigits,
  });

  /// Locale for number formatting (e.g., 'en_US', 'de_DE')
  final String? locale;

  /// Number notation style
  final NumberNotation notation;

  /// Prefix to add before the number
  final String? prefix;

  /// Suffix to add after the number
  final String? suffix;

  /// Minimum number of fraction digits to display
  final int? minimumFractionDigits;

  /// Maximum number of fraction digits to display
  final int? maximumFractionDigits;
}

/// Wrapper around intl package for number formatting
class NumberFormatter {
  NumberFormatter(this.format);

  final NumberFlowFormat format;
  NumberFormat? _numberFormat;

  /// Initialize the number formatter
  void initialize() {
    // Create NumberFormat based on configuration
    if (format.notation == NumberNotation.compact) {
      _numberFormat = NumberFormat.compact(locale: format.locale);
    } else {
      _numberFormat = NumberFormat(null, format.locale);
    }

    // Configure fraction digits
    if (format.minimumFractionDigits != null) {
      _numberFormat!.minimumFractionDigits = format.minimumFractionDigits!;
    }
    if (format.maximumFractionDigits != null) {
      _numberFormat!.maximumFractionDigits = format.maximumFractionDigits!;
    }
  }

  /// Format a number according to the configuration
  String formatNumber(num value) {
    // Initialize if not done already
    _numberFormat ??= NumberFormat();

    // Format the number
    String formatted = _numberFormat!.format(value);

    // Add prefix and suffix
    if (format.prefix != null) {
      formatted = '${format.prefix}$formatted';
    }
    if (format.suffix != null) {
      formatted = '$formatted${format.suffix}';
    }

    return formatted;
  }

  /// Get the locale string for this formatter
  String get localeString {
    // TODO: Return the locale string, defaulting to system locale if null
    return format.locale ?? 'en_US'; // Placeholder
  }
}
