// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const String initial_screen = '/';
  static const String main_screen = '/main';
  static const String final_screen = '/final';
  

  Map<String, WidgetBuilder> getRoutes() {
    return {
      initial_screen: (context) => const InitialScreen(),
      main_screen: (context) => const MainScreen(),
      final_screen: (context) => const FinalScreen(),

  };
}
}