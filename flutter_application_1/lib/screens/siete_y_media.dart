import 'dart:math';
import 'package:flutter/material.dart';

class SieteYMediaScreen extends StatefulWidget {
  const SieteYMediaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  SieteYMediaScreenState createState() => SieteYMediaScreenState();
}

class SieteYMediaScreenState extends State<SieteYMediaScreen> {
// Añadimos listas para las cartas sacadas
  final List<String> cartasUsuario = [];
  final List<String> cartasMaquina = [];

  static const List<Map<String, dynamic>> mazo = [
    // Cartas del 1 al 7 y las figuras 10, 11 y 12 para cada palo
    {'carta': '1', 'palo': 'Espada'},
    {'carta': '1', 'palo': 'Oro'},
    {'carta': '1', 'palo': 'Basto'},
    {'carta': '1', 'palo': 'Copa'},
    {'carta': '2', 'palo': 'Espada'},
    {'carta': '2', 'palo': 'Oro'},
    {'carta': '2', 'palo': 'Basto'},
    {'carta': '2', 'palo': 'Copa'},
    {'carta': '3', 'palo': 'Espada'},
    {'carta': '3', 'palo': 'Oro'},
    {'carta': '3', 'palo': 'Basto'},
    {'carta': '3', 'palo': 'Copa'},
    {'carta': '4', 'palo': 'Espada'},
    {'carta': '4', 'palo': 'Oro'},
    {'carta': '4', 'palo': 'Basto'},
    {'carta': '4', 'palo': 'Copa'},
    {'carta': '5', 'palo': 'Espada'},
    {'carta': '5', 'palo': 'Oro'},
    {'carta': '5', 'palo': 'Basto'},
    {'carta': '5', 'palo': 'Copa'},
    {'carta': '6', 'palo': 'Espada'},
    {'carta': '6', 'palo': 'Oro'},
    {'carta': '6', 'palo': 'Basto'},
    {'carta': '6', 'palo': 'Copa'},
    {'carta': '7', 'palo': 'Espada'},
    {'carta': '7', 'palo': 'Oro'},
    {'carta': '7', 'palo': 'Basto'},
    {'carta': '7', 'palo': 'Copa'},
    {'carta': '10', 'palo': 'Espada'},
    {'carta': '10', 'palo': 'Oro'},
    {'carta': '10', 'palo': 'Basto'},
    {'carta': '10', 'palo': 'Copa'},
    {'carta': '11', 'palo': 'Espada'},
    {'carta': '11', 'palo': 'Oro'},
    {'carta': '11', 'palo': 'Basto'},
    {'carta': '11', 'palo': 'Copa'},
    {'carta': '12', 'palo': 'Espada'},
    {'carta': '12', 'palo': 'Oro'},
    {'carta': '12', 'palo': 'Basto'},
    {'carta': '12', 'palo': 'Copa'},
  ];

  double puntosUsuario = 0;
  double puntosMaquina = 0;
  bool jugadorPlanta = false;
  bool maquinaPlanta = false;
  int partidasUsuario = 0;
  int partidasMaquina = 0;
  String mensajeCarta = ''; // Mensaje de la carta sacada
  Color colorMensaje = Colors.black; // Color aleatorio del mensaje

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siete y Media'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 155, 249, 246),
              Color.fromARGB(255, 24, 149, 62)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            // Centrado del contenido
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centrado verticalmente dentro del Column
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Centrado horizontalmente dentro del Column
              children: [
                Text('Partidas ganadas por el Usuario: $partidasUsuario',
                    style: const TextStyle(fontSize: 18)),
                Text('Partidas ganadas por la Máquina: $partidasMaquina',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text('Puntos del Usuario: $puntosUsuario',
                    style: const TextStyle(fontSize: 18)),
                Text('Puntos de la Máquina: $puntosMaquina',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text(mensajeCarta,
                    style: TextStyle(fontSize: 18, color: colorMensaje),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text('Cartas del Usuario: ${cartasUsuario.join(', ')}'),
                Text('Cartas de la Máquina: ${cartasMaquina.join(', ')}'),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: jugadorPlanta ||
                                puntosUsuario > 7.5 ||
                                puntosMaquina > 7 ||
                                partidasUsuario == 5 ||
                                partidasMaquina == 5 ||
                                puntosMaquina > puntosUsuario
                            ? null
                            : pedirCarta,
                        child: const Text('Pedir Carta')),
                    ElevatedButton(
                        onPressed: jugadorPlanta ||
                                puntosUsuario > 7.5 ||
                                puntosMaquina > 7 ||
                                partidasUsuario == 5 ||
                                partidasMaquina == 5 ||
                                puntosMaquina > puntosUsuario
                            ? null
                            : plantarse,
                        child: const Text('Plantarse')),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _siguienteJuego,
                  child: const Text('Siguiente Juego'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Función para obtener el valor de una carta
  double obtenerValorCarta(String carta) {
    if (carta == '10' || carta == '11' || carta == '12') {
      return 0.5; // Las figuras valen 0.5 puntos
    }
    return double.parse(carta); // El valor de las demás cartas
  }

  // Función para obtener el palo y el valor de una carta
  String obtenerDescripcionCarta(String carta, String palo) {
    if (carta == '10') {
      return 'Sota de $palo';
    } else if (carta == '11') {
      return 'Caballo de $palo';
    } else if (carta == '12') {
      return 'Rey de $palo';
    } else {
      return '$carta de $palo';
    }
  }

  // Función para generar un color aleatorio
  Color generarColorAleatorio() {
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  // Función para pedir carta
  void pedirCarta() {
    if (jugadorPlanta) return;

    var cartaSeleccionada = mazo[random.nextInt(mazo.length)];
    String carta = cartaSeleccionada['carta'];
    String palo = cartaSeleccionada['palo'];
    String descripcion = obtenerDescripcionCarta(carta, palo);

    setState(() {
      puntosUsuario += obtenerValorCarta(carta);
      cartasUsuario.add(descripcion); // Guardar carta sacada por el usuario
      mensajeCarta = 'Has sacado: $descripcion';
      colorMensaje = generarColorAleatorio();
    });

    if (puntosUsuario > 7.5) {
      mostrarGanador('Maquina');
    }
  }

//Función del juego de la máquina
  void jugarMaquina() {
    if (maquinaPlanta || puntosMaquina >= 7.5) return;

    while (puntosMaquina < 7.5 && !maquinaPlanta) {
      var cartaSeleccionada = mazo[random.nextInt(mazo.length)];
      String carta = cartaSeleccionada['carta'];
      String palo = cartaSeleccionada['palo'];
      String descripcion = obtenerDescripcionCarta(carta, palo);

      setState(() {
        puntosMaquina += obtenerValorCarta(carta);
        cartasMaquina.add(descripcion);
        mensajeCarta = 'La máquina sacó: $descripcion';
        colorMensaje = generarColorAleatorio();
      });

      // Si la máquina supera los 7.5, pierde.
      if (puntosMaquina > 7.5) {
        mostrarGanador('Usuario');
        return;
      }

      // Si la máquina tiene más puntos que el jugador, se planta.
      if (puntosMaquina > puntosUsuario) {
        maquinaPlanta = true;
        mensajeCarta = 'La máquina se ha plantado.';
        colorMensaje =
            Colors.green; // Color para indicar que la máquina se ha plantado
        break;
      }
    }

    // Si el jugador está plantado y la máquina también
    if (jugadorPlanta && maquinaPlanta) {
      if (puntosUsuario > puntosMaquina) {
        mostrarGanador('Usuario');
      } else if (puntosUsuario < puntosMaquina) {
        mostrarGanador('Maquina');
      } else {
        mostrarGanador('Empate');
      }
    }
  }

  // Función para que el jugador se plante
  void plantarse() {
    setState(() {
      jugadorPlanta = true;
    });
    jugarMaquina();
  }

//Función que muestra al ganador
  void mostrarGanador(String ganador) {
    setState(() {
      if (ganador == 'Usuario') {
        partidasUsuario++;
      } else if (ganador == 'Maquina') {
        partidasMaquina++;
      }

      mensajeCarta =
          '$ganador gana esta ronda.\nPuntuación - Usuario: $puntosUsuario, Máquina: $puntosMaquina';

      if (partidasUsuario < 5 && partidasMaquina < 5) {
        jugadorPlanta = false;
        maquinaPlanta = false;
      }
    });

    if (partidasUsuario == 5 || partidasMaquina == 5) {
      mostrarMensajeFinal(ganador == 'Usuario'
          ? '¡Has ganado 5 partidas!'
          : '¡La máquina ha ganado 5 partidas!');
    }
  }

//Función que muestra el mensaje final
  void mostrarMensajeFinal(String mensaje) {
    Future.delayed(Duration.zero, () {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible:
            false, // Evitar que el usuario cierre el diálogo sin tocar el botón
        builder: (context) {
          return AlertDialog(
            title: const Text('¡Final del Juego!'),
            content: Text(mensaje),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Reiniciar el juego
                    partidasUsuario = 0;
                    partidasMaquina = 0;
                    _nuevaPartida();
                  });
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: const Text('Reiniciar'),
              ),
            ],
          );
        },
      );
    });
  }

// Función para avanzar al siguiente juego sin reiniciar el contador de partidas ganadas
  void _siguienteJuego() {
    setState(() {
      puntosUsuario = 0;
      puntosMaquina = 0;
      jugadorPlanta = false;
      maquinaPlanta = false;
      mensajeCarta = '';
      cartasUsuario.clear();
      cartasMaquina.clear();
    });
  }

  // Función para iniciar una nueva partida
  void _nuevaPartida() {
    setState(() {
      puntosUsuario = 0;
      puntosMaquina = 0;
      jugadorPlanta = false;
      maquinaPlanta = false;
      mensajeCarta = '';
      cartasUsuario.clear();
      cartasMaquina.clear();
    });
  }
} 