import 'package:flutter/material.dart';

class UsernameModel extends ChangeNotifier {
  String _value = "";

  String get value => _value;

  void setValue(String newValue) {
    _value = newValue;
    notifyListeners();
  }
}
// Note: You can make this field either nullable (using String?) OR default the string to a certain value. 
// This will come back later in the instructions, so keep note of what you did. 
