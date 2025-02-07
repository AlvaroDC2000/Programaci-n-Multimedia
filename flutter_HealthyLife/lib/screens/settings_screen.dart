import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../drawer/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';

// Clase de la pantalla de configuración, sirve para el tema, y tipo y tamaño de letra
class SettingsScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const SettingsScreen({super.key, required bool isDarkMode, required VoidCallback toggleTheme, required double fontSize, required void Function(double p1) onFontSizeChanged, required Null Function(dynamic String) onFontStyleChanged});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String themeMode = "light";
  late double _currentFontSize;
  late String _currentFontStyle;

  @override
  void initState() {
    super.initState();
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    _currentFontSize = appSettings.fontSize;
    _currentFontStyle = appSettings.fontFamily;
    _loadSettings(); // Cargar configuración desde Firestore
  }

  /// Cargar configuración desde Firestore
  void _loadSettings() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('settings').doc('user_settings').get();

      if (snapshot.exists) {
        setState(() {
          themeMode = snapshot['theme'] ?? "light";
          _currentFontSize = (snapshot['fontSize'] ?? 16.0).toDouble();
          _currentFontStyle = snapshot['fontStyle'] ?? 'Roboto';

          final appSettings = Provider.of<AppSettings>(context, listen: false);
          appSettings.setFontSize(_currentFontSize);
          appSettings.setFontStyle(_currentFontStyle);
          if (themeMode == "dark") {
            appSettings.toggleTheme();
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al cargar configuración: $e");
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar configuración")),
      );
    }
  }

  /// Guardar configuración en Firestore
  void _saveSettings() async {
    try {
      await _firestore.collection('settings').doc('user_settings').set({
        'theme': themeMode,
        'fontSize': _currentFontSize,
        'fontStyle': _currentFontStyle,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Configuración guardada exitosamente")),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error al guardar configuración: $e");
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar configuración")),
      );
    }
  }

// Reinicia la configuración
  void _resetSettings() {
    setState(() {
      _currentFontSize = 16.0;
      _currentFontStyle = 'Roboto';
      themeMode = "light";
      
      final appSettings = Provider.of<AppSettings>(context, listen: false);
      appSettings.setFontSize(_currentFontSize);
      appSettings.setFontStyle(_currentFontStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Tema
              const Text(
                'Tema',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: Text(appSettings.isDarkMode ? 'Modo Oscuro' : 'Modo Claro'),
                value: appSettings.isDarkMode,
                onChanged: (value) {
                  appSettings.toggleTheme();
                  setState(() {
                    themeMode = appSettings.isDarkMode ? "dark" : "light";
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Tamaño de letra
              const Text(
                'Tamaño de letra',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _currentFontSize,
                min: 12.0,
                max: 24.0,
                divisions: 6,
                label: _currentFontSize.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _currentFontSize = value;
                  });
                  appSettings.setFontSize(value);
                },
              ),
              Text(
                'Vista previa del texto',
                style: GoogleFonts.getFont(_currentFontStyle, fontSize: _currentFontSize),
              ),
              const SizedBox(height: 20),

              /// Estilo de letra
              const Text(
                'Estilo de letra',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _currentFontStyle,
                items: [
                  'Roboto',
                  'Open Sans',
                  'Lato',
                  'Montserrat',
                  'Poppins',
                ].map((String font) {
                  return DropdownMenuItem<String>(
                    value: font,
                    child: Text(font, style: GoogleFonts.getFont(font)),
                  );
                }).toList(),
                onChanged: (String? newFont) {
                  setState(() {
                    _currentFontStyle = newFont!;
                  });
                  appSettings.setFontStyle(newFont!);
                },
              ),
              const SizedBox(height: 20),

              /// Botón de Restablecer
              ElevatedButton(
                onPressed: _resetSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Restablecer Configuración', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),

              /// Botón de Guardado
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Guardar Configuración"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
