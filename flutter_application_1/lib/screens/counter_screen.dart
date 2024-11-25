import 'package:flutter/material.dart';
import 'base_screen.dart';  // Importar BaseScreen

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int numeroVeces = 0;

  void incrementar() {
    setState(() {
      numeroVeces++;
    });
  }

  void decrementar() {
    setState(() {
      numeroVeces--;
    });
  }

  void resetear() {
    setState(() {
      numeroVeces = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Contador',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Has pulsado $numeroVeces veces",
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: decrementar,
                  heroTag: "btnDecrementar", // Tag único para este botón
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: resetear,
                  heroTag: "btnResetear", // Tag único para este botón
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: incrementar,
                  heroTag: "btnIncrementar", // Tag único para este botón
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
