import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../drawer/drawer.dart';
import '../main.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pasos diarios:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '8000 pasos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para añadir pasos
                    },
                    child: const Text('Añadir pasos'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Historial de sesiones:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.fitness_center, color: Colors.green),
                    title: Text('Sesión ${index + 1}'),
                    subtitle: const Text('Duración: 30 minutos'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
