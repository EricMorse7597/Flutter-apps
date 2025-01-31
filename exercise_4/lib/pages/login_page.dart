import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/username_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: userNameController,
            decoration: const InputDecoration(
              labelText: 'Enter your name',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (userNameController.text.isNotEmpty) {
                Provider.of<UsernameModel>(context, listen: false)
                    .setValue(userNameController.text);
              }
              userNameController.clear();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
