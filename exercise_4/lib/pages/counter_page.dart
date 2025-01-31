import 'package:flutter/material.dart';
import '../models/number_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final atZero = context.watch<NumberState>().value == 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<NumberState>(
              builder: (context, numberState, child) {
                return Text('the magical numba is ${numberState.value}');
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // don't allow it to into the negatives
                AbsorbPointer(
                    absorbing: atZero,
                    child: Opacity(
                      opacity: atZero ? 0.5 : 1.0,
                      child: FloatingActionButton(
                        heroTag: 'decrement',
                        onPressed: () =>
                            context.read<NumberState>().decrement(),
                        tooltip: 'Decrement',
                        child: const Icon(Icons.remove),
                      ),
                    )),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: () {
                    context.read<NumberState>().increment();
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: InputToVoid(
                onInput: (input) {
                  if (input.isNotEmpty) {
                    context.read<NumberState>().setValue(int.parse(input));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputToVoid extends StatelessWidget {
  final void Function(String) onInput;
  const InputToVoid({super.key, required this.onInput});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onInput,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a number',
        labelText: 'Set Value',
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.number,
    );
  }
}
