import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();
  int _score = 0;
  Offset _position = const Offset(100, 100); // Posición inicial de la imagen
  int _timeLeft = 5; // Tiempo restante para que se resten puntos
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    // Temporizador que cuenta los segundos
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          // Si pasa el tiempo y no se ha pulsado, resta 2 puntos
          _score -= 2;
          _timeLeft = 5; // Reinicia el temporizador
          // Cambia la posición de la imagen
          _position = _generateRandomPosition();
        }
      });
    });
  }

  void _onTap() {
    setState(() {
      _score += 1; // Aumenta la puntuación si se pulsa la imagen
      _timeLeft = 5; // Reinicia el temporizador al pulsar
      // Mueve la imagen a una nueva posición aleatoria
      _position = _generateRandomPosition();
    });
  }

  Offset _generateRandomPosition() {
    return Offset(
      _random.nextDouble() * (MediaQuery.of(context).size.width - 50),
      _random.nextDouble() * (MediaQuery.of(context).size.height - 50),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Imágenes'),
      ),
      body: Stack(
        children: [
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onTap: _onTap,
              child: Image.asset(
                'assets/Images/perfil.jpg',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Text(
              'Puntuación: $_score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: Text(
              'Tiempo: $_timeLeft s',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
