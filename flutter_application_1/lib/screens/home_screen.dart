import 'package:flutter/material.dart';
import '../drawer/drawer.dart';

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomeScreen({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tema Personalizado',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.white, // Asegura que el texto sea visible en ambos modos
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode, // Cambia el ícono entre sol y luna, no me funciona revisar
              color: isDarkMode ? Colors.yellow : Colors.white, // Color del ícono en cada modo
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Este es un texto con estilo personalizado',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Botón Elevado'),
            ),
          ],
        ),
      ),
    );
  }
}
