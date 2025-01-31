import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/username_model.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered),
            label: 'Factors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Profile',
          )
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/counter')) {
      return 0;
    }
    if (location.startsWith('/factors')) {
      return 1;
    }
    if (location.startsWith('/login')) {
      return 2;
    }
    if (location.startsWith('/user')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/counter');
        break;
      case 1:
        GoRouter.of(context).go('/factors');
        break;
      case 2:
        GoRouter.of(context).go('/login');
        break;
      case 3:
        String name = Provider.of<UsernameModel>(context, listen: false).value;
        if (name.isEmpty) {
          GoRouter.of(context).go('/user/Invalid_User');
        } else {
          GoRouter.of(context).go('/user/$name');
        }
        // Instruction 5: For context, we are going to be modifying a route here, where we will be reading from the UsernameModel.
        // You'll note, in the code for the login page, we are not doing any Provider.of. That is because we are going to be passing
        // the userId through the route using dynamic routing in GoRouter.
        // Here, you will need to
        // 1. Read the name from the model (using Provider.of)
        // 2. Check if the name is your default value from Instruction 2. If it is, go to the route '/user/Invalid_User'.
        // 3. If the name is not null, pass in the userId into the route.

        break;
    }
  }
}
