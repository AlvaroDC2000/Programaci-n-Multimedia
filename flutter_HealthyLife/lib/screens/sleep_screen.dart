import 'package:flutter/material.dart';
import '../drawer/drawer.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sueño'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registra tus horas de sueño:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 7, // Ejemplo: cambiar con datos reales
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.bedtime, color: Colors.purple),
                    title: Text('Noche ${index + 1}'),
                    subtitle: const Text('Horas dormidas: 8 horas'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para registrar una nueva noche de sueño
              },
              child: const Text('Registrar horas de sueño'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Consejos para un mejor sueño:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.lightbulb, color: Colors.orange),
                    title: Text('Evita las pantallas 30 minutos antes de dormir.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.timer, color: Colors.orange),
                    title: Text('Mantén un horario constante para ir a dormir.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.fitness_center, color: Colors.orange),
                    title: Text('Haz ejercicio regularmente, pero evita hacerlo antes de dormir.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.bedtime, color: Colors.orange),
                    title: Text('Asegúrate de que tu habitación esté oscura y silenciosa.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_drink, color: Colors.orange),
                    title: Text('Evita consumir cafeína por la tarde o noche.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

