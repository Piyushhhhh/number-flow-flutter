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
      title: 'NumberFlow Examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NumberFlow Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildExampleCard(
            context,
            'Basics',
            'Basic number animations with different styles',
            Icons.numbers,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BasicsScreen()),
            ),
          ),
          _buildExampleCard(
            context,
            'Decimals',
            'Decimal number animations and formatting',
            Icons.aspect_ratio,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DecimalsScreen()),
            ),
          ),
          _buildExampleCard(
            context,
            'Compact',
            'Compact notation (K, M, B) animations',
            Icons.compress,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompactScreen()),
            ),
          ),
          _buildExampleCard(
            context,
            'Group Sync',
            'Synchronized animations across multiple widgets',
            Icons.sync,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GroupSyncScreen()),
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
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
