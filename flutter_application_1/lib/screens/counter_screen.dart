import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Álvaro Díaz Casaño"))),
      body: Center(
        child: Text(
          "Has pulsado $numeroVeces veces",
          style: const TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: decrementar,
            heroTag: "btnDecrementar", // Tag único para este botón
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: resetear,
            heroTag: "btnResetear", // Tag único para este botón
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            onPressed: incrementar,
            heroTag: "btnIncrementar", // Tag único para este botón
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}