import 'package:flutter/material.dart';
import 'package:number_flow/number_flow.dart';

class BasicsScreen extends StatefulWidget {
  const BasicsScreen({super.key});

  @override
  State<BasicsScreen> createState() => _BasicsScreenState();
}

class _BasicsScreenState extends State<BasicsScreen> {
  double _currentValue = 1234;
  double? _previousValue;
  NumberFlowAnimation _animationStyle = NumberFlowAnimation.slide;

  void _updateValue() {
    setState(() {
      _previousValue = _currentValue;
      _currentValue = (_currentValue * 1.5) % 10000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Basic Number Animation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // TODO: Implement NumberFlow widget display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: NumberFlow(
                value: _currentValue,
                previousValue: _previousValue,
                textStyle: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                animationStyle: _animationStyle,
                duration: const Duration(milliseconds: 800),
              ),
            ),

            const SizedBox(height: 32),

            // Animation style selector
            const Text('Animation Style:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SegmentedButton<NumberFlowAnimation>(
              segments: const [
                ButtonSegment(
                  value: NumberFlowAnimation.slide,
                  label: Text('Slide'),
                ),
                ButtonSegment(
                  value: NumberFlowAnimation.spin,
                  label: Text('Spin'),
                ),
                ButtonSegment(
                  value: NumberFlowAnimation.crossFade,
                  label: Text('Fade'),
                ),
              ],
              selected: {_animationStyle},
              onSelectionChanged: (Set<NumberFlowAnimation> selected) {
                setState(() {
                  _animationStyle = selected.first;
                });
              },
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _updateValue,
              child: const Text('Update Number'),
            ),

            const SizedBox(height: 16),

            const Text(
              'Tap "Update Number" to see the animation in action. '
              'Try different animation styles to see how they look.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
