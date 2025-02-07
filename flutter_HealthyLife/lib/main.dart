import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importación de Firestore
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Configuración correcta de Firebase
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: const MyApp(),
    ),
  );
}

// Instancia global de Firestore
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Clase del main
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    final appRoutes = AppRoutes(
      isDarkMode: appSettings.isDarkMode,
      toggleTheme: appSettings.toggleTheme,
      fontSize: appSettings.fontSize,
      onFontSizeChanged: appSettings.setFontSize,
      onFontStyleChanged: appSettings.setFontStyle,
    );

    return MaterialApp(
      title: 'HealthyLife',
      debugShowCheckedModeBanner: false,
      themeMode: appSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFE8F5E9), // Blanco verdoso
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF81C784), // Verde pastel
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF81C784), // Verde pastel
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.getFont(appSettings.fontFamily, fontSize: appSettings.fontSize, color: Colors.grey[800]),
          titleLarge: GoogleFonts.getFont(appSettings.fontFamily, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF7043),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7043),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.getFont(appSettings.fontFamily, fontSize: appSettings.fontSize, color: Colors.grey[300]),
          titleLarge: GoogleFonts.getFont(appSettings.fontFamily, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
      ),
      initialRoute: AppRoutes.login,
      routes: appRoutes.getRoutes(),
    );
  }
}

// Configuración de ajustes
class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  String _fontFamily = 'Roboto';

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  void setFontStyle(String newFontFamily) {
    _fontFamily = newFontFamily;
    notifyListeners();
  }
}
