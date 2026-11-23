import 'package:flutter/material.dart';
import 'package:flutter_number_flow/flutter_number_flow.dart';

import '../core/metrics_cache.dart';

/// Animated presenter for an individual formatted-number glyph.
class GlyphStack extends StatelessWidget {
  const GlyphStack({
    super.key,
    required this.oldGlyph,
    required this.newGlyph,
    required this.textStyle,
    required this.animation,
    required this.animationStyle,
  });

  /// Previous glyph (null if this glyph is being inserted).
  final String? oldGlyph;

  /// Current glyph (null if this glyph is being removed).
  final String? newGlyph;

  /// Text style to apply to the glyph.
  final TextStyle textStyle;

  /// Animation driving the transition.
  final Animation<double> animation;

  /// Style of animation to use.
  final NumberFlowAnimation animationStyle;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) => _buildAnimatedGlyph(),
      );

  Widget _buildAnimatedGlyph() {
    final oldValue = oldGlyph;
    final newValue = newGlyph;
    final progress = animation.value.clamp(0.0, 1.0).toDouble();

    if (oldValue == newValue) {
      return _buildStaticGlyph(newValue ?? '');
    }
    if (oldValue == null) {
      return _buildInsertion(newValue!, progress);
    }
    if (newValue == null) {
      return _buildDeletion(oldValue, progress);
    }

    return _buildReplacement(oldValue, newValue, progress);
  }

  Widget _buildStaticGlyph(String glyph) => SizedBox(
        width: _getGlyphWidth(glyph),
        child: Align(
          alignment: Alignment.center,
          child: Text(glyph, style: textStyle),
        ),
      );

  Widget _buildInsertion(String glyph, double progress) {
    final height = _getGlyphHeight(glyph);
    final offset = animationStyle == NumberFlowAnimation.slide
        ? Offset(0, height * (1 - progress))
        : Offset.zero;

    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: offset,
            child: Text(glyph, style: textStyle),
          ),
        ),
      ),
    );
  }

  Widget _buildDeletion(String glyph, double progress) {
    final remaining = 1 - progress;
    final height = _getGlyphHeight(glyph);
    final offset = animationStyle == NumberFlowAnimation.slide
        ? Offset(0, -height * progress)
        : Offset.zero;

    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: remaining,
        child: Opacity(
          opacity: remaining,
          child: Transform.translate(
            offset: offset,
            child: Text(glyph, style: textStyle),
          ),
        ),
      ),
    );
  }

  Widget _buildReplacement(
    String oldValue,
    String newValue,
    double progress,
  ) {
    final oldSize = _getGlyphSize(oldValue);
    final newSize = _getGlyphSize(newValue);
    final width = oldSize.width + (newSize.width - oldSize.width) * progress;
    final height =
        oldSize.height > newSize.height ? oldSize.height : newSize.height;
    final slide = animationStyle == NumberFlowAnimation.slide;

    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: slide ? 1 : 1 - progress,
              child: Transform.translate(
                offset: slide ? Offset(0, -height * progress) : Offset.zero,
                child: Text(oldValue, style: textStyle),
              ),
            ),
            Opacity(
              opacity: slide ? 1 : progress,
              child: Transform.translate(
                offset:
                    slide ? Offset(0, height * (1 - progress)) : Offset.zero,
                child: Text(newValue, style: textStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Size _getGlyphSize(String glyph) =>
      TextMetricsCache().getMetrics(glyph, textStyle).size;

  double _getGlyphWidth(String glyph) => _getGlyphSize(glyph).width;

  double _getGlyphHeight(String glyph) => _getGlyphSize(glyph).height;
}
