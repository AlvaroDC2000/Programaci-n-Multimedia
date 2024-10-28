import 'package:flutter/material.dart';

class ColumnImagesScreen extends StatelessWidget {
  const ColumnImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imágenes en Columna'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/Images/Malaga.jpg', width: 200, height: 200),
          const SizedBox(height: 10),
          Image.asset('assets/Images/Granada.webp', width: 200, height: 200),
          const SizedBox(height: 10),
          Image.asset('assets/Images/Cadiz.jpeg', width: 200, height: 200),
        ],
      ),
    );
  }
}
