import 'package:flutter/material.dart';

import 'screens/basics_screen.dart';
import 'screens/decimals_screen.dart';
import 'screens/compact_screen.dart';
import 'screens/group_sync_screen.dart';
import 'screens/scrub_timeline_screen.dart';

void main() {
  runApp(const NumberFlowExampleApp());
}

class NumberFlowExampleApp extends StatelessWidget {
  const NumberFlowExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Number Flow',
      theme: _buildFuturisticTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildFuturisticTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A0A0F),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00D4FF),
        secondary: Color(0xFF7C4DFF),
        surface: Color(0xFF1A1A24),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFFE1E1E6),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A24),
        elevation: 8,
        shadowColor: const Color(0xFF00D4FF).withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFF00D4FF).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4FF),
          foregroundColor: const Color(0xFF000000),
          elevation: 4,
          shadowColor: const Color(0xFF00D4FF).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A24),
        foregroundColor: Color(0xFFE1E1E6),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE1E1E6),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0F),
              Color(0xFF1A1A24),
              Color(0xFF0A0A0F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Futuristic header
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF7C4DFF)],
                      ).createShader(bounds),
                      child: const Text(
                        'FLUTTER',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const Text(
                      'NUMBER FLOW',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF00D4FF),
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 2,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFF7C4DFF)],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildExampleCard(
                      context,
                      'Basics',
                      'Basic number animations with different styles',
                      Icons.numbers,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BasicsScreen()),
                      ),
                    ),
                    _buildExampleCard(
                      context,
                      'Decimals',
                      'Decimal number animations and formatting',
                      Icons.aspect_ratio,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DecimalsScreen()),
                      ),
                    ),
                    _buildExampleCard(
                      context,
                      'Compact',
                      'Compact notation (K, M, B) animations',
                      Icons.compress,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompactScreen()),
                      ),
                    ),
                    _buildExampleCard(
                      context,
                      'Group Sync',
                      'Synchronized animations across multiple widgets',
                      Icons.sync,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GroupSyncScreen()),
                      ),
                    ),
                    _buildExampleCard(
                      context,
                      'Scrub Timeline',
                      'Manual animation control with timeline scrubbing',
                      Icons.timeline,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScrubTimelineScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A24),
            Color(0xFF242432),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00D4FF), Color(0xFF7C4DFF)],
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE1E1E6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFE1E1E6).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF00D4FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
