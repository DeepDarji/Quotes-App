// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivational Quotes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Light mode
      darkTheme: AppTheme.darkTheme, // Dark mode
      themeMode: ThemeMode.system, // Use system setting
      home: const HomeScreen(), // First screen
    );
  }
}
