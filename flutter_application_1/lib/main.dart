import 'package:flutter/material.dart';
import 'screens/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Variable para controlar el modo claro/oscuro
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Instancia de AppRoutes pasando los valores necesarios
    final appRoutes = AppRoutes(isDarkMode: isDarkMode, toggleTheme: toggleTheme);

    return MaterialApp(
      title: 'Tema Personalizado',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 242, 244, 244),
          foregroundColor: Color.fromARGB(255, 180, 213, 95),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      initialRoute: AppRoutes.home,
      // Usamos la instancia de appRoutes para acceder a getRoutes()
      routes: appRoutes.getRoutes(),
    );
  }
}

