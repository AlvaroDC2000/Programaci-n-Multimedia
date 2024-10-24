import 'package:flutter/material.dart';

  void main() => 
runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ejemplo de filas y columnas anidadas'),
        ),
        body : Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset('lib/assets/Images/telefono.jpg', width: 50, height: 50),
                      const Text('Teléfono'),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('lib/assets/Images/mensaje.webp', width: 50, height: 50),
                      const Text('Mensajes'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 80), // Espaciado entre filas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset('lib/assets/Images/instagram.webp', width: 50, height: 50),
                      const Text('Instagram'),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('lib/assets/Images/whatsapp.png', width: 50, height: 50),
                      const Text('WhatsApp'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
