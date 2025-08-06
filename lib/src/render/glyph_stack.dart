import 'package:flutter/material.dart';
import '../../number_flow.dart';
import '../core/metrics_cache.dart';

/// Animated presenter for individual glyphs with different animation styles
class GlyphStack extends StatefulWidget {
  const GlyphStack({
    super.key,
    required this.oldGlyph,
    required this.newGlyph,
    required this.textStyle,
    required this.animation,
    required this.animationStyle,
  });

  /// Previous glyph (null if this is a new glyph)
  final String? oldGlyph;

  /// Current glyph (null if this glyph was removed)
  final String? newGlyph;

  /// Text style to apply to the glyph
  final TextStyle textStyle;

  /// Animation controller driving the transition
  final Animation<double> animation;

  /// Style of animation to use
  final NumberFlowAnimation animationStyle;

  @override
  State<GlyphStack> createState() => _GlyphStackState();
}

class _GlyphStackState extends State<GlyphStack> {
  late final TextMetricsCache _metricsCache;

  @override
  void initState() {
    super.initState();
    _metricsCache = TextMetricsCache();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement glyph animation based on animation style
    // - Handle slide animation (vertical movement)
    // - Handle spin animation (3D rotation)
    // - Handle crossFade animation (opacity transition)
    // - Use cached metrics for consistent sizing
    // - Return appropriate animated widget

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return _buildAnimatedGlyph();
      },
    );
  }

  /// Build the animated glyph based on the animation style
  Widget _buildAnimatedGlyph() {
    switch (widget.animationStyle) {
      case NumberFlowAnimation.slide:
        return _buildSlideAnimation();
      case NumberFlowAnimation.spin:
        return _buildSpinAnimation();
      case NumberFlowAnimation.crossFade:
        return _buildCrossFadeAnimation();
    }
  }

  /// Build slide animation (vertical movement)
  Widget _buildSlideAnimation() {
    final String? oldGlyph = widget.oldGlyph;
    final String? newGlyph = widget.newGlyph;
    
    // If no animation needed, just show the current glyph
    if (oldGlyph == null || newGlyph == null || oldGlyph == newGlyph) {
      return SizedBox(
        width: _getGlyphWidth(newGlyph ?? oldGlyph ?? ''),
        child: Text(
          newGlyph ?? oldGlyph ?? '',
          style: widget.textStyle,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Get metrics for consistent sizing
    final width = _getGlyphWidth(newGlyph);
    final height = _getGlyphHeight(newGlyph);

    // Animation progress
    final progress = widget.animation.value;
    
    // Calculate slide positions
    final oldOffset = Offset(0, -height * progress);
    final newOffset = Offset(0, height * (1 - progress));

    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            // Old glyph sliding up
            Transform.translate(
              offset: oldOffset,
              child: Text(
                oldGlyph,
                style: widget.textStyle,
                textAlign: TextAlign.center,
              ),
            ),
            // New glyph sliding in from below
            Transform.translate(
              offset: newOffset,
              child: Text(
                newGlyph,
                style: widget.textStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build spin animation (3D rotation)
  Widget _buildSpinAnimation() {
    final String? oldGlyph = widget.oldGlyph;
    final String? newGlyph = widget.newGlyph;
    
    // If no animation needed, just show the current glyph
    if (oldGlyph == null || newGlyph == null || oldGlyph == newGlyph) {
      return SizedBox(
        width: _getGlyphWidth(newGlyph ?? oldGlyph ?? ''),
        child: Text(
          newGlyph ?? oldGlyph ?? '',
          style: widget.textStyle,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Get metrics for consistent sizing
    final width = _getGlyphWidth(newGlyph);
    final height = _getGlyphHeight(newGlyph);

    // Animation progress
    final progress = widget.animation.value;
    
    // Switch glyph at 50% progress for flip effect
    final showOld = progress < 0.5;
    final currentGlyph = showOld ? oldGlyph : newGlyph;
    
    // Calculate rotation angle (0 to π)
    final angle = progress * 3.14159;
    
    // Scale effect to simulate 3D perspective
    final scale = (1.0 - (progress - 0.5).abs() * 2).clamp(0.3, 1.0);

    return SizedBox(
      width: width,
      height: height,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Add perspective
          ..rotateX(angle)
          ..scale(scale),
        child: Text(
          currentGlyph,
          style: widget.textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Build cross-fade animation (opacity transition)
  Widget _buildCrossFadeAnimation() {
    final String? oldGlyph = widget.oldGlyph;
    final String? newGlyph = widget.newGlyph;
    
    // If no animation needed, just show the current glyph
    if (oldGlyph == null || newGlyph == null || oldGlyph == newGlyph) {
      return SizedBox(
        width: _getGlyphWidth(newGlyph ?? oldGlyph ?? ''),
        child: Text(
          newGlyph ?? oldGlyph ?? '',
          style: widget.textStyle,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Get metrics for consistent sizing
    final width = _getGlyphWidth(newGlyph);
    final height = _getGlyphHeight(newGlyph);

    // Animation progress
    final progress = widget.animation.value;
    
    // Calculate opacities
    final oldOpacity = 1.0 - progress;
    final newOpacity = progress;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Old glyph fading out
          Opacity(
            opacity: oldOpacity,
            child: Text(
              oldGlyph,
              style: widget.textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          // New glyph fading in
          Opacity(
            opacity: newOpacity,
            child: Text(
              newGlyph,
              style: widget.textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Get the size for this glyph using the metrics cache
  Size _getGlyphSize(String glyph) {
    final metrics = _metricsCache.getMetrics(glyph, widget.textStyle);
    return metrics.size;
  }

  /// Get the width for this glyph using the metrics cache
  double _getGlyphWidth(String glyph) {
    return _getGlyphSize(glyph).width;
  }

  /// Get the height for this glyph using the metrics cache
  double _getGlyphHeight(String glyph) {
    return _getGlyphSize(glyph).height;
  }
}
