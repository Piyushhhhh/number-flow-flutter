import 'package:flutter/material.dart';
import 'package:flutter_number_flow/number_flow.dart';

class CompactScreen extends StatefulWidget {
  const CompactScreen({super.key});

  @override
  State<CompactScreen> createState() => _CompactScreenState();
}

class _CompactScreenState extends State<CompactScreen> {
  double _followers = 1234567;
  double? _previousFollowers;
  double _downloads = 987654321;
  double? _previousDownloads;

  void _updateFollowers() {
    setState(() {
      _previousFollowers = _followers;
      _followers = _followers +
          (50000 + (DateTime.now().millisecondsSinceEpoch % 100000));
    });
  }

  void _updateDownloads() {
    setState(() {
      _previousDownloads = _downloads;
      _downloads = _downloads +
          (1000000 + (DateTime.now().millisecondsSinceEpoch % 5000000));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compact Notation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Followers display
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people, size: 48, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Social Media Followers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // TODO: Implement compact notation NumberFlow
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: NumberFlow(
                      value: _followers,
                      previousValue: _previousFollowers,
                      format: const NumberFlowFormat(
                        notation: NumberNotation.compact,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      animationStyle: NumberFlowAnimation.slide,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Full: ${_followers.toInt().toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}',
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateFollowers,
                    child: const Text('Gain Followers'),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Downloads display
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download, size: 48, color: Colors.purple),
                  const SizedBox(height: 16),
                  const Text(
                    'App Downloads',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // TODO: Implement compact notation NumberFlow with different style
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: NumberFlow(
                      value: _downloads,
                      previousValue: _previousDownloads,
                      format: const NumberFlowFormat(
                        notation: NumberNotation.compact,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                      animationStyle: NumberFlowAnimation.spin,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Full: ${_downloads.toInt().toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}',
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateDownloads,
                    child: const Text('More Downloads'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
