import 'dart:async';

import 'package:flutter/material.dart';

/// Provides shared AnimationController for synchronized NumberFlow animations
class NumberFlowGroup extends InheritedWidget {
  const NumberFlowGroup({
    super.key,
    required this.groupKey,
    required this.controller,
    required this.curve,
    required super.child,
  });

  /// Unique key identifying this animation group
  final String groupKey;

  /// Shared animation controller for the group
  final AnimationController controller;

  /// Curve applied consistently to every animation in the group.
  final Curve curve;

  /// Get the NumberFlowGroup from context
  static NumberFlowGroup? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NumberFlowGroup>();

  /// Check if a NumberFlowGroup with the given key exists in context
  static NumberFlowGroup? findByKey(BuildContext context, String groupKey) {
    final group = of(context);
    return (group?.groupKey == groupKey) ? group : null;
  }

  /// Restart the shared animation timeline from its beginning.
  void restart() {
    unawaited(controller.forward(from: 0));
  }

  @override
  bool updateShouldNotify(NumberFlowGroup oldWidget) =>
      groupKey != oldWidget.groupKey ||
      controller != oldWidget.controller ||
      curve != oldWidget.curve;
}

/// Provider widget that creates and manages a NumberFlowGroup
class NumberFlowGroupProvider extends StatefulWidget {
  const NumberFlowGroupProvider({
    super.key,
    required this.groupKey,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
  });

  /// Unique key for this animation group
  final String groupKey;

  /// Child widget tree
  final Widget child;

  /// Animation duration for the group
  final Duration duration;

  /// Animation curve for the group
  final Curve curve;

  @override
  State<NumberFlowGroupProvider> createState() =>
      _NumberFlowGroupProviderState();
}

class _NumberFlowGroupProviderState extends State<NumberFlowGroupProvider>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      value: 1,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(NumberFlowGroupProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NumberFlowGroup(
        groupKey: widget.groupKey,
        controller: _controller,
        curve: widget.curve,
        child: widget.child,
      );
}
