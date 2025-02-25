import 'package:flutter/material.dart';
import 'base_screen.dart';

class RowImagesScreen extends StatelessWidget {
  const RowImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Imágenes en Fila',
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/Images/Malaga.jpg', width: 100, height: 100),
          Image.asset('assets/Images/Cadiz.jpeg', width: 100, height: 100),
          Image.asset('assets/Images/Granada.webp', width: 100, height: 100),
        ],
      ),
    );
  }
}
