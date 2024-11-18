import 'package:flutter/material.dart';
import '../drawer/drawer.dart';

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> toggleTheme;

  const HomeScreen({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tema Personalizado', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              toggleTheme(!isDarkMode);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Este es un texto con estilo personalizado', style: Theme.of(context).textTheme.bodyMedium),
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

