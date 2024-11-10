import 'package:flutter/material.dart';
import '../drawer/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demostración de cajón'),
      ),
      drawer: const AppDrawer(),
      body: const Center(child: Text("Selecciona una opción del cajón")),
    );
  }
}
