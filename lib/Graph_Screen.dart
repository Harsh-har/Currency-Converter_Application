import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final Map<String, double> data;
  const SimpleBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxValue = data.values.isEmpty ? 1 : data.values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text("Currency Chart")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 50, child: Text(entry.key)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 24,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: Text(
                      entry.value.toStringAsFixed(2),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
