import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase_options.dart';
import 'routes/app_routes.dart';
import 'providers/auth_client_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final keepLoggedIn = prefs.getBool('keep_logged_in') ?? false;
  final currentUser = FirebaseAuth.instance.currentUser;

  final appSettings = AppSettings();

  if (keepLoggedIn && currentUser != null) {
    await loadUserSettings(appSettings);
  }

  final initialRoute =
      (keepLoggedIn && currentUser != null) ? AppRoutes.lists : AppRoutes.login;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appSettings),
        ChangeNotifierProvider(create: (_) => AuthClientProvider()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

/// Carga la configuración de Firestore del usuario logueado
Future<void> loadUserSettings(AppSettings appSettings) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('settings')
      .doc(user.uid)
      .get();

  if (doc.exists) {
    final data = doc.data()!;
    appSettings.setFontSize((data['fontSize'] ?? 16.0).toDouble());
    appSettings.setFontStyle(data['fontStyle'] ?? 'Roboto');
    final isDark = (data['theme'] ?? 'light') == 'dark';
    if (isDark != appSettings.isDarkMode) {
      appSettings.toggleTheme();
    }
  }
}

// Configuración global del usuario
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

  void reset() {}
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

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
      title: 'ListaYa',
      debugShowCheckedModeBanner: false,
      themeMode: appSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color.fromARGB(255, 58, 198, 142),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 58, 198, 142),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 54, 180, 111),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.getFont(
            appSettings.fontFamily,
            fontSize: appSettings.fontSize,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.getFont(
            appSettings.fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
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
          bodyMedium: GoogleFonts.
          getFont(
            appSettings.fontFamily,
            fontSize: appSettings.fontSize,
            color: Colors.grey[300],
          ),
          titleLarge: GoogleFonts.getFont(
            appSettings.fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ),
      initialRoute: initialRoute,
      routes: appRoutes.getRoutes(),
    );
  }
}
