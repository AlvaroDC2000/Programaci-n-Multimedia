import 'package:flutter/material.dart';

class FormSelectionScreen extends StatelessWidget {
  const FormSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Formulario'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            title: const Text('Formulario 1'),
            onTap: () {
              Navigator.pushNamed(context, '/formulario1'); 
            },
          ),
          ListTile(
            title: const Text('Formulario 2'),
            onTap: () {
              Navigator.pushNamed(context, '/formulario2'); 
            },
          ),
          ListTile(
            title: const Text('Formulario 3'),
            onTap: () {
              Navigator.pushNamed(context, '/formulario3'); 
            },
          ),
          ListTile(
            title: const Text('Formulario 4'),
            onTap: () {
              Navigator.pushNamed(context, '/formulario4'); 
            },
          ),
        ],
      ),
    );
  }
}
