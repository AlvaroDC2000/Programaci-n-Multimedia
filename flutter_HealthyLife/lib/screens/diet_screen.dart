import 'package:flutter/material.dart';
import '../drawer/drawer.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietas'),
        backgroundColor:  const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registra tus comidas y calorías:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Ejemplo: cambiar con datos reales
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.restaurant_menu, color: Colors.orange),
                    title: Text('Comida ${index + 1}'),
                    subtitle: const Text('Calorías: 500 kcal'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para implatar apis
              },
              child: const Text('Registrar comida'),
            ),
          ],
        ),
      ),
    );
  }
}
