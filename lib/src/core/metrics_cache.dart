import 'package:flutter/material.dart';

/// Cache key for text metrics
class MetricsCacheKey {
  const MetricsCacheKey({
    required this.glyph,
    required this.textStyle,
  });

  final String glyph;
  final TextStyle textStyle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetricsCacheKey &&
          runtimeType == other.runtimeType &&
          glyph == other.glyph &&
          textStyle == other.textStyle;

  @override
  int get hashCode => glyph.hashCode ^ textStyle.hashCode;
}

/// Cached text metrics for a specific glyph and style
class CachedTextMetrics {
  const CachedTextMetrics({
    required this.size,
    required this.baseline,
  });

  /// Size of the rendered text
  final Size size;

  /// Baseline offset from top
  final double baseline;
}

/// Cache for TextPainter measurements to avoid repeated calculations
class TextMetricsCache {
  static final TextMetricsCache _instance = TextMetricsCache._internal();
  factory TextMetricsCache() => _instance;
  TextMetricsCache._internal();

  final Map<MetricsCacheKey, CachedTextMetrics> _cache = {};
  static const int _maxCacheSize = 1000;

  /// Get cached metrics for a glyph and style, or measure and cache if not present
  CachedTextMetrics getMetrics(String glyph, TextStyle textStyle) {
    final key = MetricsCacheKey(glyph: glyph, textStyle: textStyle);

    // Return cached metrics if available
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    // Clear cache if it gets too large
    if (_cache.length >= _maxCacheSize) {
      _cache.clear();
    }

    // Measure and cache the metrics
    final metrics = _measureText(glyph, textStyle);
    _cache[key] = metrics;
    return metrics;
  }

  /// Measure text using TextPainter
  CachedTextMetrics _measureText(String glyph, TextStyle textStyle) {
    // TODO: Implement text measurement using TextPainter
    // - Create TextPainter with the glyph and style
    // - Layout the text
    // - Extract size and baseline information
    // - Return CachedTextMetrics

    final textPainter = TextPainter(
      text: TextSpan(text: glyph, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    return CachedTextMetrics(
      size: Size(textPainter.width, textPainter.height),
      baseline:
          textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic),
    );
  }

  /// Clear the entire cache
  void clear() {
    _cache.clear();
  }

  /// Get current cache size
  int get cacheSize => _cache.length;
}
