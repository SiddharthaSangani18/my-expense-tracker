import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

// Every Dart/Flutter app starts at main().
void main() {
  runApp(const MyApp());
}

// MyApp is the root widget. It sets up the theme and the first screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Dark colour scheme with one subtle accent colour (teal).
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4DB6AC),
          surface: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const HomeScreen(),
    );
  }
}
