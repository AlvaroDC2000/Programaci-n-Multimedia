import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../drawer/drawer.dart';
import '../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required bool isDarkMode,
    required VoidCallback toggleTheme,
    required double fontSize,
    required void Function(double p1) onFontSizeChanged,
    required void Function(String) onFontStyleChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late double _currentFontSize;
  late String _currentFontStyle;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    _currentFontSize = appSettings.fontSize;
    _currentFontStyle = appSettings.fontFamily;
    _isDarkMode = appSettings.isDarkMode;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final snapshot = await _firestore.collection('settings').doc('user_settings').get();
      if (snapshot.exists) {
        setState(() {
          _currentFontSize = (snapshot['fontSize'] ?? 16.0).toDouble();
          _currentFontStyle = snapshot['fontStyle'] ?? 'Roboto';
          _isDarkMode = (snapshot['theme'] ?? 'light') == 'dark';

          final appSettings = Provider.of<AppSettings>(context, listen: false);
          appSettings.setFontSize(_currentFontSize);
          appSettings.setFontStyle(_currentFontStyle);
          if (_isDarkMode != appSettings.isDarkMode) {
            appSettings.toggleTheme();
          }
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar configuración')),
      );
    }
  }

  Future<void> _saveSettings() async {
    try {
      await _firestore.collection('settings').doc('user_settings').set({
        'theme': _isDarkMode ? 'dark' : 'light',
        'fontSize': _currentFontSize,
        'fontStyle': _currentFontStyle,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuración guardada')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar configuración')),
      );
    }
  }

  void _resetSettings() {
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    setState(() {
      _currentFontSize = 16.0;
      _currentFontStyle = 'Roboto';
      _isDarkMode = false;

      appSettings.setFontSize(_currentFontSize);
      appSettings.setFontStyle(_currentFontStyle);
      if (appSettings.isDarkMode) {
        appSettings.toggleTheme();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF26C485),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            SizedBox(
              height: 180,
              child: Image.asset(
                'assets/Images/ListaYaLogo.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

            // Drawer botón
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),

            // Título
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Configuración',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tema',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    SwitchListTile(
                      title: Text(_isDarkMode ? 'Modo Oscuro' : 'Modo Claro'),
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() => _isDarkMode = value);
                        appSettings.toggleTheme();
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Tamaño de letra',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Slider(
                      value: _currentFontSize,
                      min: 12.0,
                      max: 24.0,
                      divisions: 6,
                      label: _currentFontSize.toStringAsFixed(0),
                      onChanged: (value) {
                        setState(() => _currentFontSize = value);
                        appSettings.setFontSize(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    Text('Vista previa del texto',
                        style: GoogleFonts.getFont(_currentFontStyle,
                            fontSize: _currentFontSize, color: Colors.white)),
                    const SizedBox(height: 20),
                    const Text('Estilo de letra',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    DropdownButton<String>(
                      value: _currentFontStyle,
                      isExpanded: true,
                      dropdownColor: Colors.white,
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
                        if (newFont != null) {
                          setState(() => _currentFontStyle = newFont);
                          appSettings.setFontStyle(newFont);
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _resetSettings,
                          icon: const Icon(Icons.restart_alt),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          label: const Text('Restablecer'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _saveSettings,
                          icon: const Icon(Icons.save),
                          label: const Text('Guardar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
