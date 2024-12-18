import 'dart:math';
import 'package:flutter/material.dart';

class Formulario2Screen extends StatefulWidget {
  const Formulario2Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Formulario2ScreenState createState() => _Formulario2ScreenState();
}

class _Formulario2ScreenState extends State<Formulario2Screen> {
  final TextEditingController _numberController = TextEditingController();
  late int _targetNumber;
  String _feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _generateTargetNumber();
  }

  void _generateTargetNumber() {
    _targetNumber = Random().nextInt(100) + 1; // Genera un número entre 1 y 100.
  }

  void _validateInput() {
    int? guessedNumber = int.tryParse(_numberController.text);

    if (guessedNumber == null) {
      _showSnackbar("Por favor, introduce un número válido.");
      return;
    }

    if (guessedNumber < _targetNumber) {
      setState(() {
        _feedbackMessage = "El número es mayor.";
      });
    } else if (guessedNumber > _targetNumber) {
      setState(() {
        _feedbackMessage = "El número es menor.";
      });
    } else {
      _showSuccessDialog();
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¡Felicidades!"),
        content: Text("Has acertado el número: $_targetNumber"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _feedbackMessage = '';
                _generateTargetNumber();
                _numberController.clear();
              });
            },
            child: const Text("Jugar de nuevo"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adivina el número"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Intenta adivinar un número entre 1 y 100:",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Introduce tu número",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateInput,
              child: const Text("Comprobar"),
            ),
            const SizedBox(height: 20),
            Text(
              _feedbackMessage,
              style: TextStyle(
                fontSize: 18,
                color: _feedbackMessage.contains("mayor")
                    ? Colors.blue
                    : _feedbackMessage.contains("menor")
                        ? Colors.red
                        : Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
