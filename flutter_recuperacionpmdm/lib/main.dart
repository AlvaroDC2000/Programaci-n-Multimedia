import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
  
 @override
  Widget build(BuildContext context) {
    final appRoutes = AppRoutes();

    return MaterialApp(
      initialRoute: AppRoutes.initial_screen,
      routes: appRoutes.getRoutes(),
    );
  }
}
