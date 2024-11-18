import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

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
          backgroundColor: Colors.teal,
          foregroundColor: Colors.yellow, // Ajustamos el color de ícono para visibilidad en tema oscuro
          iconTheme: IconThemeData(color: Colors.yellow), // Color de ícono en tema oscuro
        ),
      ),
      initialRoute: AppRoutes.home,
      routes: appRoutes.getRoutes(),
    );
  }
}
