import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();
  int _score = 0;
  Offset _position = const Offset(150, 150); // Posición inicial de la imagen
  int _timeLeft = 5; // Tiempo restante para que se resten puntos
  Timer? _countdownTimer;
  String? _message;
  Color? _messageColor;

  static const double imageSize = 100; // Tamaño de la imagen
  static const double squareSize = 400; // Tamaño del área de juego

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _position = _generateRandomPosition(); // Generar posición inicial válida
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _score -= 2;
          _message = '¡Perdiste 2 puntos!';
          _messageColor = Colors.red; // Mensaje en rojo
          _timeLeft = 5;
          _position = _generateRandomPosition(); // Cambiar posición
          _clearMessageAfterDelay();
        }
      });
    });
  }

  void _onTap() {
    setState(() {
      _score += 1;
      _message = '¡Ganaste 1 punto!';
      _messageColor = _generateRandomColor();
      _timeLeft = 5;
      _position = _generateRandomPosition();
      _clearMessageAfterDelay();
    });
  }

  Offset _generateRandomPosition() {
    // Genera una posición aleatoria dentro del cuadrado de juego
    return Offset(
      _random.nextDouble() * (squareSize - imageSize),
      _random.nextDouble() * (squareSize - imageSize),
    );
  }

  Color _generateRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  void _clearMessageAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _message = null; // Limpia el mensaje tras 2 segundos
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final centerX = (MediaQuery.of(context).size.width - squareSize) / 2;
    const double topOffset = 150.0; // Espacio reservado para el marcador

    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Imágenes'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color.fromARGB(255, 179, 203, 252)), // Fondo azul
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Puntuación: $_score',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tiempo: $_timeLeft s',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (_message != null) // Mostrar mensaje si existe
                  Text(
                    _message!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _messageColor,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: centerX,
            top: topOffset,
            child: Container(
              width: squareSize,
              height: squareSize,
              color: Colors.blue.shade300, // Color del área de juego
              child: Stack(
                children: [
                  Positioned(
                    left: _position.dx,
                    top: _position.dy,
                    child: GestureDetector(
                      onTap: _onTap,
                      child: Image.asset(
                        'assets/Images/perfil.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 20.0, // Mensaje al pie de la pantalla
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '¡Juego desarrollado por Álvaro Díaz Casaño!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
