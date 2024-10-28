import 'package:flutter/material.dart';
import 'widgets/drawer.dart';

void main() {
  runApp(const Principal());
}

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demostración de cajón'),
        ),
        drawer: const AppDrawer(),
        body: const Center(child: Text("Selecciona una opción del cajón")),
      ),
    );
  }
}
