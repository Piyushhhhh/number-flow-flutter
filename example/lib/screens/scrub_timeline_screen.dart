import 'package:flutter/material.dart';
import 'package:flutter_number_flow/flutter_number_flow.dart';

class ScrubTimelineScreen extends StatefulWidget {
  const ScrubTimelineScreen({super.key});

  @override
  State<ScrubTimelineScreen> createState() => _ScrubTimelineScreenState();
}

class _ScrubTimelineScreenState extends State<ScrubTimelineScreen> {
  double _scrubProgress = 0.0;
  final double _startValue = 0;
  final double _endValue = 1000000;
  bool _isAutoPlaying = false;

  double get _currentValue =>
      _startValue + (_endValue - _startValue) * _scrubProgress;

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
    });

    if (_isAutoPlaying) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    if (!_isAutoPlaying) return;

    // Simple auto-play implementation using Future.delayed
    // In a production app, this would use an AnimationController
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_isAutoPlaying && mounted) {
        setState(() {
          _scrubProgress = (_scrubProgress + 0.01) % 1.0;
        });
        _startAutoPlay();
      }
    });
  }

  void _resetProgress() {
    setState(() {
      _scrubProgress = 0.0;
      _isAutoPlaying = false;
    });
  }

  /// Helper method to format values for display
  String _formatValue(num value, NumberFlowFormat format) {
    if (format.notation == NumberNotation.compact) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}K';
      }
    }
    return '${format.prefix ?? ''}${value.toInt()}${format.suffix ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrub Timeline'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Project Budget Timeline',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // NumberFlow with manual scrub progress control
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade50, Colors.purple.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: NumberFlow(
                value: _currentValue,
                previousValue: _startValue,
                format: const NumberFlowFormat(
                  prefix: '\$',
                  notation: NumberNotation.compact,
                  maximumFractionDigits: 2,
                ),
                textStyle: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                scrubProgress: _scrubProgress, // Manual progress control
                animationStyle: NumberFlowAnimation.slide,
              ),
            ),

            const SizedBox(height: 32),

            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Progress: ${(_scrubProgress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            // Scrub slider
            const Text('Timeline Control:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Slider(
              value: _scrubProgress,
              onChanged: (value) {
                setState(() {
                  _scrubProgress = value;
                  _isAutoPlaying =
                      false; // Stop auto-play when manually scrubbing
                });
              },
              divisions: 100,
              label: '${(_scrubProgress * 100).round()}%',
            ),

            const SizedBox(height: 16),

            // Range labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start: ${_formatValue(_startValue, const NumberFlowFormat(prefix: '\$', notation: NumberNotation.compact))}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'End: ${_formatValue(_endValue, const NumberFlowFormat(prefix: '\$', notation: NumberNotation.compact))}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleAutoPlay,
                  icon: Icon(_isAutoPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isAutoPlaying ? 'Pause' : 'Auto Play'),
                ),
                ElevatedButton.icon(
                  onPressed: _resetProgress,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Use the slider to manually control the animation progress, '
              'or tap "Auto Play" to see it animate automatically. '
              'This demonstrates precise control over NumberFlow animations.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
