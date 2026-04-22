import 'package:flutter/material.dart';
import 'screens/starting_screen.dart';

void main() {
  runApp(const ChefGPTApp());
}

class ChefGPTApp extends StatelessWidget {
  const ChefGPTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChefGPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE63946),
          surface: const Color(0xFFFFF8E1),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        useMaterial3: true,
      ),
      home: const StartingScreen(),
    );
  }
}
