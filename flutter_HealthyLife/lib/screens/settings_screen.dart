import 'package:flutter/material.dart';
import '../drawer/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const SettingsScreen({super.key, required void Function(double p1) onFontSizeChanged, required bool isDarkMode, required VoidCallback toggleTheme, required double fontSize, required Null Function(dynamic String) onFontStyleChanged});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _currentFontSize;
  late String _currentFontStyle;

  @override
  void initState() {
    super.initState();
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    _currentFontSize = appSettings.fontSize;
    _currentFontStyle = appSettings.fontFamily;
  }

  void _resetSettings() {
    setState(() {
      final appSettings = Provider.of<AppSettings>(context, listen: false);
      _currentFontSize = 16.0;
      _currentFontStyle = 'Roboto';
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
              const Text(
                'Tema',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SwitchListTile(
                title: Text(appSettings.isDarkMode ? 'Modo Oscuro' : 'Modo Claro'),
                value: appSettings.isDarkMode,
                onChanged: (value) {
                  appSettings.toggleTheme();
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Tamaño de letra',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
              const Text(
                'Estilo de letra',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
              ElevatedButton(
                onPressed: _resetSettings,
                child: const Text('Restablecer Configuración'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

