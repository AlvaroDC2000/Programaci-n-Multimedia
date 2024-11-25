import 'package:flutter/material.dart';
import 'base_screen.dart';

class NestedRowsColumnsScreen extends StatelessWidget {
  const NestedRowsColumnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Filas y Columnas Anidadas',
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset('assets/Images/telefono.jpg', width: 50, height: 50),
                    const Text('Teléfono'),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/Images/mensaje.webp', width: 50, height: 50),
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
                    Image.asset('assets/Images/instagram.webp', width: 50, height: 50),
                    const Text('Instagram'),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/Images/whatsapp.png', width: 50, height: 50),
                    const Text('WhatsApp'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
