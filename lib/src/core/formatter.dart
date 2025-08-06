import 'package:intl/intl.dart';
import '../../number_flow.dart';

/// Configuration for number formatting
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
  late final NumberFormat _numberFormat;

  /// Initialize the number formatter
  void initialize() {
    // TODO: Initialize NumberFormat based on format configuration
    // - Handle locale
    // - Handle notation (standard vs compact)
    // - Handle min/max fraction digits
    // - Create appropriate NumberFormat instance
  }

  /// Format a number according to the configuration
  String formatNumber(num value) {
    // TODO: Format the number using the configured NumberFormat
    // - Apply prefix/suffix if specified
    // - Return formatted string
    return value.toString(); // Placeholder
  }

  /// Get the locale string for this formatter
  String get localeString {
    // TODO: Return the locale string, defaulting to system locale if null
    return format.locale ?? 'en_US'; // Placeholder
  }
}
