import 'package:flutter/material.dart';
import '../screens/screens.dart';

// Clase para las rutas de la app
class AppRoutes {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final double fontSize;
  final void Function(double) onFontSizeChanged;

  AppRoutes({
    required this.isDarkMode,
    required this.toggleTheme,
    required this.fontSize,
    required this.onFontSizeChanged, required void Function(String newFontFamily) onFontStyleChanged,
  });

  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String hydration = '/hydration';
  static const String exercise = '/exercise';
  static const String sleep = '/sleep';
  static const String diet = '/diet';
  static const String settings = '/settings';
  static const String profile = '/profile';

  Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => HomeScreen(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
      ),
      hydration: (context) => const HydrationScreen(),
      exercise: (context) => const ExerciseScreen(),
      sleep: (context) => const SleepScreen(),
      diet: (context) => const DietScreen(),
      settings: (context) => SettingsScreen(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
        fontSize: fontSize,
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        onFontSizeChanged: onFontSizeChanged, onFontStyleChanged: (String ) {  },
      ),
      profile: (context) => const ProfileScreen(),
    };
  }
}
