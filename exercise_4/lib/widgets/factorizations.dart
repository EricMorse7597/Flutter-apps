import 'package:flutter/material.dart';

class Factorizations extends StatelessWidget {
  final int number;

  List<int> get _factors {
    assert(number >= 0);

    final List<int> factors = [];
    for (var i = 2; i <= number; i++) {
      if (number % i == 0) {
        factors.add(i);
      }
    }
    return factors;
  }

  const Factorizations({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Text('$_factors');
  }
}
