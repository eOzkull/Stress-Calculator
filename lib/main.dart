import 'package:flutter/material.dart';
import 'package:stress_calculator/screens/home_screen.dart';
import 'package:stress_calculator/theme/app_theme.dart';
import 'package:stress_calculator/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeService = ThemeService();
  await themeService.init();
  runApp(const StressCalculatorApp());
}

class StressCalculatorApp extends StatelessWidget {
  const StressCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService().themeModeNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'Stress Calculator',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
