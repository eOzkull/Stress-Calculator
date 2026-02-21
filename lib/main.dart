import 'package:flutter/material.dart';
import 'package:stress_calculator/screens/home_screen.dart';
import 'package:stress_calculator/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StressCalculatorApp());
}

class StressCalculatorApp extends StatelessWidget {
  const StressCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stress Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}