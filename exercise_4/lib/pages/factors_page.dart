import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/factorizations.dart';
import '../models/number_model.dart';

class FactorsPage extends StatelessWidget {
  const FactorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Factorizations')),
      body: Center(
        child: Consumer<NumberState>(
          builder: (context, numberState, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Factors of ${numberState.value}:'),
                const SizedBox(height: 20),
                Factorizations(number: numberState.value),
              ],
            );
          },
        ),
      ),
    );
  }
}
