import 'package:flutter/material.dart';
import '../screens/screens.dart';

// Clase para las rutas de la app
class AppRoutes {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final double fontSize;
  final void Function(double) onFontSizeChanged;
  final void Function(String newFontFamily) onFontStyleChanged;

  AppRoutes({
    required this.isDarkMode,
    required this.toggleTheme,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.onFontStyleChanged,
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
      lists: (context) => const ListsScreen(authClient: null),
      task: (context) => const TaskScreen(authClient: null),
      settings: (context) => SettingsScreen(
            isDarkMode: isDarkMode,
            toggleTheme: toggleTheme,
            fontSize: fontSize,
            onFontSizeChanged: onFontSizeChanged,
            onFontStyleChanged: onFontStyleChanged,
          ),
      profile: (context) => const ProfileScreen(),
      finished: (context) => const FinishedScreen(),

      // NUEVO: modificar para aceptar argumentos de Navigator
      modify: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

        return ModifyScreen(
          initialName: args?['initialName'] ?? '',
          initialDescription: args?['initialDescription'] ?? '',
          initialDate: args?['initialDate'],
          taskId: args?['taskId'],
          isGoogleTask: args?['isGoogleTask'] ?? false,
          taskListId: args?['taskListId'],
          initialTasks: const [],
        );
      }
    };
  }
}
