import 'package:flutter/material.dart';

/// Configuration for edge masking
class MaskConfig {
  const MaskConfig({
    this.enabled = true,
    this.fadeHeight = 0.2,
    this.clipBehavior = Clip.antiAlias,
  }) : assert(fadeHeight >= 0 && fadeHeight <= 0.5);

  /// Whether masking is enabled
  final bool enabled;

  /// Height of fade effect as fraction of widget height (0.0 to 0.5)
  final double fadeHeight;

  /// Clipping behavior for the mask
  final Clip clipBehavior;
}

/// Applies gradient edge masking to content for smooth overflow handling
class EdgeMask extends StatelessWidget {
  const EdgeMask({
    super.key,
    required this.child,
    required this.config,
  });

  /// Widget to apply masking to
  final Widget child;

  /// Mask configuration
  final MaskConfig config;

  @override
  Widget build(BuildContext context) {
    if (!config.enabled) {
      return child;
    }

    return ShaderMask(
      shaderCallback: _createMaskGradient,
      blendMode: BlendMode.dstIn,
      child: ClipRect(
        clipBehavior: config.clipBehavior,
        child: child,
      ),
    );
  }

  /// Create the masking gradient
  Shader _createMaskGradient(Rect bounds) {
    final fadePixels = bounds.height * config.fadeHeight;
    final fadeStop = fadePixels / bounds.height;

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [
        Colors.transparent,
        Colors.black,
        Colors.black,
        Colors.transparent,
      ],
      stops: [
        0.0,
        fadeStop,
        1.0 - fadeStop,
        1.0,
      ],
    ).createShader(bounds);
  }
}

/// Clips content with optional rounded corners and overflow handling
class ContentClipper extends StatelessWidget {
  const ContentClipper({
    super.key,
    required this.child,
    this.borderRadius,
    this.clipBehavior = Clip.hardEdge,
  });

  /// Widget to clip
  final Widget child;

  /// Border radius for clipping
  final BorderRadius? borderRadius;

  /// Clipping behavior
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    if (borderRadius == null) {
      return ClipRect(
        clipBehavior: clipBehavior,
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
