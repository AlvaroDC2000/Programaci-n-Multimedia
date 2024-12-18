import 'package:flutter/material.dart';
import 'base_screen.dart';

class IconsScreen extends StatelessWidget {
  const IconsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Mostrar Iconos',
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, size: 50, color: Colors.blue),
          Icon(Icons.star, size: 50, color: Colors.yellow),
          Icon(Icons.favorite, size: 50, color: Colors.red),
          Icon(Icons.person, size: 50, color: Colors.green),
          Icon(Icons.settings, size: 50, color: Colors.purple),
        ],
      ),
    );
  }
}

