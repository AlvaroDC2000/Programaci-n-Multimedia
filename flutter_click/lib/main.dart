import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Álvaro Díaz', home: MiContador());
  }
}

class MiContador extends StatefulWidget {
  const MiContador({super.key});

  @override
  State<MiContador> createState() => _MiContadorState();
}

class _MiContadorState extends State<MiContador> {
  int numeroVeces = 0;

  incrementar() {
    setState(() {
      numeroVeces++;
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
        )),
        floatingActionButton: FloatingActionButton(
            onPressed: incrementar, child: const Text("Pulsa")));
  }
}
