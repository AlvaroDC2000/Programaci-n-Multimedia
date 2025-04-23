import 'package:firebase_auth/firebase_auth.dart';
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
    required void Function(double) onFontSizeChanged,
    required void Function(String) onFontStyleChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late double _currentFontSize = 16.0;
  late String _currentFontStyle = 'Roboto';
  late bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('settings').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _currentFontSize = (data['fontSize'] ?? 16.0).toDouble();
        _currentFontStyle = data['fontStyle'] ?? 'Roboto';
        _isDarkMode = (data['theme'] ?? 'light') == 'dark';
      });

      // ignore: use_build_context_synchronously
      final appSettings = Provider.of<AppSettings>(context, listen: false);
      appSettings.setFontSize(_currentFontSize);
      appSettings.setFontStyle(_currentFontStyle);
      if (_isDarkMode != appSettings.isDarkMode) {
        appSettings.toggleTheme();
      }
    }
  }

  Future<void> _saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('settings').doc(user.uid).set({
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
        SnackBar(content: Text('Error al guardar configuración: $e')),
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
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

            // Botón Drawer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: textColor, size: 30),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),

            // Título
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Configuración',
                  style: TextStyle(
                    color: textColor,
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
                    Text('Tema',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    SwitchListTile(
                      title: Text(_isDarkMode ? 'Modo Oscuro' : 'Modo Claro',
                          style: TextStyle(color: textColor)),
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() => _isDarkMode = value);
                        appSettings.toggleTheme();
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('Tamaño de letra',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
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
                            fontSize: _currentFontSize, color: textColor)),
                    const SizedBox(height: 20),
                    Text('Estilo de letra',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
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
