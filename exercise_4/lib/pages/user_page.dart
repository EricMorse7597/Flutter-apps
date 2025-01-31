import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final String? userId;

  const UserPage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
      ),
      body: Center(
        child: Text(
          'Welcome, User: $userId',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
