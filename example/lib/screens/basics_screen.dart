import 'package:flutter/material.dart';
import 'package:flutter_number_flow/flutter_number_flow.dart';

class BasicsScreen extends StatefulWidget {
  const BasicsScreen({super.key});

  @override
  State<BasicsScreen> createState() => _BasicsScreenState();
}

class _BasicsScreenState extends State<BasicsScreen> {
  double _currentValue = 1234.56;
  double? _previousValue;
  NumberFlowAnimation _animationStyle = NumberFlowAnimation.slide;

  void _updateValue() {
    setState(() {
      _previousValue = _currentValue;
      // Generate a random number with 2 decimal places
      _currentValue = double.parse(
          ((_currentValue * 1.23 + 111.11) % 10000).toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BASICS'),
        backgroundColor: const Color(0xFF1A1A24),
        foregroundColor: const Color(0xFFE1E1E6),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0F),
              Color(0xFF1A1A24),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Glowing title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00D4FF), Color(0xFF7C4DFF)],
                ).createShader(bounds),
                child: const Text(
                  'BASIC NUMBER ANIMATION',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Futuristic number display container
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1A24),
                      Color(0xFF242432),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF00D4FF).withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: NumberFlow(
                  value: _currentValue,
                  previousValue: _previousValue,
                  format: const NumberFlowFormat(
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF00D4FF),
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                  animationStyle: _animationStyle,
                  duration: const Duration(milliseconds: 800),
                ),
              ),

              const SizedBox(height: 40),

              // Futuristic animation selector
              Column(
                children: [
                  const Text(
                    'ANIMATION STYLE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE1E1E6),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF1A1A24),
                      border: Border.all(
                        color: const Color(0xFF00D4FF).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAnimationButton(
                            'SLIDE', NumberFlowAnimation.slide),
                        _buildAnimationButton(
                            'FADE', NumberFlowAnimation.crossFade),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Futuristic update button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF7C4DFF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _updateValue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'UPDATE NUMBER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Tap "UPDATE NUMBER" to see the animation in action.\nTry different animation styles to see how they look.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFFE1E1E6).withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationButton(String label, NumberFlowAnimation animation) {
    final isSelected = _animationStyle == animation;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _animationStyle = animation;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF7C4DFF)],
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : const Color(0xFFE1E1E6),
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
