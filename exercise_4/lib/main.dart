import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import './models/number_model.dart';
import './pages/login_page.dart';
import './widgets/scaffold_with_nav_bar.dart';
import './pages/counter_page.dart';
import './pages/user_page.dart';
import './models/username_model.dart';
import './pages/factors_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NumberState()),
        ChangeNotifierProvider(create: (context) => UsernameModel()),
      ],
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/counter',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/counter',
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/counter',
          builder: (context, state) => const CounterPage(),
        ),
        GoRoute(
          path: '/factors',
          builder: (context, state) => const FactorsPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/user/:userId',
          builder: (context, state) =>
              UserPage(userId: state.pathParameters['userId']),
        )
        // Instruction 6: Actually add the path here for '/user/:userId'.
        // Note that the parameter is gotten through 'state.pathParameters['userId']'.
        // You will get this userId and store it in a variable. Then, instantiate the UserPage
        // widget with the userId found. (UserPage(userId: userId))
      ],
    ),
  ],
);

// Template MyApp with default colour scheme; this should not need to be touched.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Primal desire',
      routerConfig: _router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.white,
          cardColor: Colors.white,
          errorColor: Colors.red,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
