import 'package:flutter/material.dart';

class NumberState extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void increment() => setValue(_value + 1);

  void decrement() => setValue(_value - 1);

  void setValue(int newValue) {
    _value = newValue;
    notifyListeners();
  }
}
