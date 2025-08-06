import 'package:flutter/material.dart';
import 'package:flutter_number_flow/number_flow.dart';

class DecimalsScreen extends StatefulWidget {
  const DecimalsScreen({super.key});

  @override
  State<DecimalsScreen> createState() => _DecimalsScreenState();
}

class _DecimalsScreenState extends State<DecimalsScreen> {
  double _temperature = 98.6;
  double? _previousTemperature;
  double _price = 123.45;
  double? _previousPrice;

  void _updateTemperature() {
    setState(() {
      _previousTemperature = _temperature;
      _temperature =
          95.0 + (DateTime.now().millisecondsSinceEpoch % 1000) / 100;
    });
  }

  void _updatePrice() {
    setState(() {
      _previousPrice = _price;
      _price = 100.0 + (DateTime.now().millisecondsSinceEpoch % 10000) / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decimals'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Temperature display
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Temperature Monitor',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // TODO: Implement temperature NumberFlow with decimal formatting
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NumberFlow(
                          value: _temperature,
                          previousValue: _previousTemperature,
                          format: const NumberFlowFormat(
                            minimumFractionDigits: 1,
                            maximumFractionDigits: 1,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const Text(
                          '°F',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateTemperature,
                    child: const Text('Take Reading'),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Price display
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Stock Price',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // TODO: Implement price NumberFlow with currency formatting
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: NumberFlow(
                      value: _price,
                      previousValue: _previousPrice,
                      format: const NumberFlowFormat(
                        prefix: '\$',
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      animationStyle: NumberFlowAnimation.slide,
                    ),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updatePrice,
                    child: const Text('Update Price'),
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
