import 'package:flutter/material.dart';

class ComplexLayoutScreen extends StatelessWidget {
  const ComplexLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disposición en Forma de Flecha'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Primera fila (1 elemento en el centro)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset('assets/Images/Malaga.jpg', width: 50, height: 50),
                    const Text('Malaga'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Segunda fila (2 elementos)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(Icons.phone, size: 50, color: Colors.blue),
                    Text('Teléfono'),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Icon(Icons.map, size: 50, color: Colors.green),
                    Text('Mapa'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tercera fila (3 elementos)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset('assets/Images/Granada.webp', width: 50, height: 50),
                    const Text('Granada'),
                  ],
                ),
                const SizedBox(width: 20),
                const Column(
                  children: [
                    Icon(Icons.camera_alt, size: 50, color: Colors.orange),
                    Text('Cámara'),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Image.asset('assets/Images/Cadiz.jpeg', width: 50, height: 50),
                    const Text('Cadiz'),
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
