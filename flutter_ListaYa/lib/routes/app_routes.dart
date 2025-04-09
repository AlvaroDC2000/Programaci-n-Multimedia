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
  static const String lists = '/lists';
  static const String task = '/task';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String finished = '/finished';
  static const String modify = '/modify';

  Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      lists: (context) => const ListsScreen(
      ),
      task: (context) => const TaskScreen(),
      settings: (context) => SettingsScreen(
        isDarkMode: isDarkMode,
        toggleTheme: toggleTheme,
        fontSize: fontSize,
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        onFontSizeChanged: onFontSizeChanged, onFontStyleChanged: (String ) {  },
      ),
      profile: (context) => const ProfileScreen(),
      finished: (context) => const FinishedScreen(),
      modify: (context) => const ModifyScreen(initialName: '', initialTasks: [],),
    };
  }
}