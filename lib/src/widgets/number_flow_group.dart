import 'package:flutter/material.dart';

/// Provides shared AnimationController for synchronized NumberFlow animations
class NumberFlowGroup extends InheritedWidget {
  const NumberFlowGroup({
    super.key,
    required this.groupKey,
    required this.controller,
    required super.child,
  });

  /// Unique key identifying this animation group
  final String groupKey;

  /// Shared animation controller for the group
  final AnimationController controller;

  /// Get the NumberFlowGroup from context
  static NumberFlowGroup? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NumberFlowGroup>();
  }

  /// Check if a NumberFlowGroup with the given key exists in context
  static NumberFlowGroup? findByKey(BuildContext context, String groupKey) {
    final group = of(context);
    return (group?.groupKey == groupKey) ? group : null;
  }

  @override
  bool updateShouldNotify(NumberFlowGroup oldWidget) {
    return groupKey != oldWidget.groupKey || controller != oldWidget.controller;
  }
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
  Widget build(BuildContext context) {
    return NumberFlowGroup(
      groupKey: widget.groupKey,
      controller: _controller,
      child: widget.child,
    );
  }

  /// Start animation for all NumberFlow widgets in this group
  void startGroupAnimation() {
    // TODO: Implement group animation coordination
    // - Reset and start the shared controller
    // - Notify all NumberFlow widgets in the group
    // - Handle animation state management

    _controller.reset();
    _controller.forward();
  }

  /// Stop animation for the group
  void stopGroupAnimation() {
    _controller.stop();
  }

  /// Reset animation for the group
  void resetGroupAnimation() {
    _controller.reset();
  }
}
