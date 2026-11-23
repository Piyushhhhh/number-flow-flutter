import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_number_flow/flutter_number_flow.dart';

import '../core/diff.dart';
import '../render/glyph_stack.dart';
import '../render/mask.dart';

/// Displays a formatted number and animates only the glyphs that change.
class NumberFlow extends StatefulWidget {
  const NumberFlow({
    super.key,
    required this.value,
    this.previousValue,
    this.textStyle,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
    this.animationStyle = NumberFlowAnimation.slide,
    this.format,
    this.textAlign = TextAlign.center,
    this.groupKey,
    this.scrubProgress,
    this.enableMask = true,
    this.maskConfig = const MaskConfig(),
  });

  /// Current number value to display.
  final num value;

  /// Explicit animation start value, or null to use the preceding [value].
  final num? previousValue;

  /// Text style for the number display.
  final TextStyle? textStyle;

  /// Animation duration when this widget is not controlled by a group.
  final Duration duration;

  /// Animation curve when this widget is not controlled by a group.
  final Curve curve;

  /// Animation style to use.
  final NumberFlowAnimation animationStyle;

  /// Number formatting configuration.
  final NumberFlowFormat? format;

  /// Text alignment within the available width.
  final TextAlign textAlign;

  /// Key of the nearest [NumberFlowGroupProvider] to use.
  final String? groupKey;

  /// Manual transition progress from [previousValue] to [value].
  ///
  /// Values outside 0–1 are clamped. Supplying a value disables automatic
  /// playback without affecting other widgets in a group.
  final double? scrubProgress;

  /// Whether to enable edge masking.
  final bool enableMask;

  /// Configuration for edge masking.
  final MaskConfig maskConfig;

  @override
  State<NumberFlow> createState() => _NumberFlowState();
}

class _NumberFlowState extends State<NumberFlow> with TickerProviderStateMixin {
  late final AnimationController _localController;
  late AnimationController _effectiveController;
  late Animation<double> _animation;
  late NumberFormatter _formatter;

  NumberFlowGroup? _group;
  String _currentText = '';
  String _previousText = '';
  List<CharacterDiff> _diffs = const [];
  bool _initialAnimationScheduled = false;
  bool _initialAnimationPending = false;

  @override
  void initState() {
    super.initState();
    _localController = AnimationController(
      duration: widget.duration,
      value: 1,
      vsync: this,
    );
    _effectiveController = _localController;
    _effectiveController.addStatusListener(_handleAnimationStatus);
    _animation = _effectiveController.drive(CurveTween(curve: widget.curve));

    _formatter = NumberFormatter(widget.format ?? const NumberFlowFormat());
    _formatter.initialize();
    _initializeFormattedValues();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configureAnimation(_findGroup());
    _scheduleInitialAnimation();
  }

  @override
  void didUpdateWidget(NumberFlow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _localController.duration = widget.duration;
    }

    if (widget.groupKey != oldWidget.groupKey) {
      _configureAnimation(_findGroup());
    } else if (widget.curve != oldWidget.curve) {
      _configureAnimation(_group);
    }

    final endpointsChanged = widget.value != oldWidget.value ||
        widget.previousValue != oldWidget.previousValue ||
        widget.format != oldWidget.format;

    if (endpointsChanged) {
      _initialAnimationPending = false;
      final oldTargetText = _currentText;

      if (widget.format != oldWidget.format) {
        _formatter = NumberFormatter(widget.format ?? const NumberFlowFormat());
        _formatter.initialize();
      }

      _currentText = _formatter.formatNumber(widget.value);
      _previousText = widget.previousValue == null
          ? oldTargetText
          : _formatter.formatNumber(widget.previousValue!);
      _calculateDiffs();

      if (_hasTransition) {
        _startAnimation();
      }
    } else if (oldWidget.scrubProgress != null &&
        widget.scrubProgress == null &&
        _hasTransition) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _effectiveController.removeStatusListener(_handleAnimationStatus);
    _localController.dispose();
    super.dispose();
  }

  NumberFlowGroup? _findGroup() {
    final key = widget.groupKey;
    return key == null ? null : NumberFlowGroup.findByKey(context, key);
  }

  void _configureAnimation(NumberFlowGroup? group) {
    final controller = group?.controller ?? _localController;
    if (!identical(controller, _effectiveController)) {
      _effectiveController.removeStatusListener(_handleAnimationStatus);
      _effectiveController = controller;
      _effectiveController.addStatusListener(_handleAnimationStatus);
    }

    _group = group;
    _animation = _effectiveController.drive(
      CurveTween(curve: group?.curve ?? widget.curve),
    );
  }

  void _initializeFormattedValues() {
    _currentText = _formatter.formatNumber(widget.value);
    _previousText = widget.previousValue == null
        ? _currentText
        : _formatter.formatNumber(widget.previousValue!);
    _calculateDiffs();
  }

  void _calculateDiffs() {
    _diffs = StringDiffer.calculateDiff(_previousText, _currentText);
  }

  bool get _hasTransition => _diffs.any((diff) => diff.oldChar != diff.newChar);

  void _scheduleInitialAnimation() {
    if (_initialAnimationScheduled ||
        widget.previousValue == null ||
        widget.scrubProgress != null ||
        !_hasTransition) {
      return;
    }

    _initialAnimationScheduled = true;
    _initialAnimationPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_initialAnimationPending) {
        return;
      }
      _initialAnimationPending = false;
      _startAnimation();
    });
  }

  void _startAnimation() {
    if (widget.scrubProgress != null) {
      return;
    }

    final group = _group;
    if (group != null) {
      group.restart();
    } else {
      unawaited(_localController.forward(from: 0));
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed ||
        !mounted ||
        widget.scrubProgress != null ||
        !_hasTransition) {
      return;
    }

    setState(() {
      _previousText = _currentText;
      _calculateDiffs();
    });
  }

  Animation<double> get _displayAnimation {
    final progress = widget.scrubProgress;
    if (progress == null) {
      return _animation;
    }

    final clamped = progress.clamp(0.0, 1.0).toDouble();
    final curved = widget.curve.transform(clamped).clamp(0.0, 1.0).toDouble();
    return AlwaysStoppedAnimation<double>(curved);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _getEffectiveTextStyle();
    Widget content = _buildNumberDisplay(textStyle, _displayAnimation);
    content = _applyAlignment(content);

    if (widget.enableMask) {
      content = EdgeMask(config: widget.maskConfig, child: content);
    }

    return Semantics(
      label: _currentText,
      child: ExcludeSemantics(child: content),
    );
  }

  TextStyle _getEffectiveTextStyle() {
    final baseStyle = widget.textStyle ?? DefaultTextStyle.of(context).style;
    return baseStyle.copyWith(
      fontFeatures: [
        const FontFeature.tabularFigures(),
        ...?baseStyle.fontFeatures,
      ],
    );
  }

  Widget _buildNumberDisplay(
    TextStyle textStyle,
    Animation<double> animation,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          for (final diff in _diffs)
            GlyphStack(
              oldGlyph: diff.oldChar,
              newGlyph: diff.newChar,
              textStyle: textStyle,
              animation: animation,
              animationStyle: widget.animationStyle,
            ),
        ],
      );

  Widget _applyAlignment(Widget content) {
    switch (widget.textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        return Align(alignment: Alignment.centerLeft, child: content);
      case TextAlign.right:
      case TextAlign.end:
        return Align(alignment: Alignment.centerRight, child: content);
      case TextAlign.center:
        return Align(alignment: Alignment.center, child: content);
      case TextAlign.justify:
        return content;
    }
  }
}
