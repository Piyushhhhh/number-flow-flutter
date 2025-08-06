import 'package:flutter/material.dart';
import 'package:flutter_number_flow/number_flow.dart';

class GroupSyncScreen extends StatefulWidget {
  const GroupSyncScreen({super.key});

  @override
  State<GroupSyncScreen> createState() => _GroupSyncScreenState();
}

class _GroupSyncScreenState extends State<GroupSyncScreen> {
  double _revenue = 1500000;
  double _expenses = 980000;
  double _profit = 520000;

  double? _previousRevenue;
  double? _previousExpenses;
  double? _previousProfit;

  void _updateFinancials() {
    setState(() {
      _previousRevenue = _revenue;
      _previousExpenses = _expenses;
      _previousProfit = _profit;

      // Simulate quarterly update
      final growth = 1.1 + (DateTime.now().millisecondsSinceEpoch % 100) / 1000;
      _revenue = _revenue * growth;
      _expenses = _expenses * (growth * 0.9); // Expenses grow slower
      _profit = _revenue - _expenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Synchronization'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Financial Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'All numbers animate together when updated',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // TODO: Implement NumberFlowGroupProvider to synchronize animations
            NumberFlowGroupProvider(
              groupKey: 'financials',
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  // Revenue card
                  _buildFinancialCard(
                    'Revenue',
                    _revenue,
                    _previousRevenue,
                    Colors.green,
                    Icons.trending_up,
                  ),

                  const SizedBox(height: 16),

                  // Expenses card
                  _buildFinancialCard(
                    'Expenses',
                    _expenses,
                    _previousExpenses,
                    Colors.red,
                    Icons.trending_down,
                  ),

                  const SizedBox(height: 16),

                  // Profit card
                  _buildFinancialCard(
                    'Profit',
                    _profit,
                    _previousProfit,
                    Colors.blue,
                    Icons.account_balance_wallet,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _updateFinancials,
              child: const Text('Update Quarterly Report'),
            ),

            const SizedBox(height: 16),

            const Text(
              'Notice how all three numbers animate simultaneously when updated. '
              'This is achieved using NumberFlowGroup synchronization.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard(
    String label,
    double value,
    double? previousValue,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // TODO: Implement synchronized NumberFlow widgets
                  NumberFlow(
                    value: value,
                    previousValue: previousValue,
                    format: const NumberFlowFormat(
                      prefix: '\$',
                      notation: NumberNotation.compact,
                      maximumFractionDigits: 2,
                    ),
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    groupKey:
                        'financials', // Same group key for synchronization
                    animationStyle: NumberFlowAnimation.slide,
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
