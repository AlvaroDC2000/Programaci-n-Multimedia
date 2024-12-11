import 'package:flutter/material.dart';
import 'grid_view.dart';

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 300, // Ajustar si es necesario
      child: TabBarView(
        children: [
          // Fotos publicadas
          GridViewWidget(imagePaths: [
            'assets/Images/Malaga.jpg',
            'assets/Images/Granada.webp',
            'assets/Images/Cadiz.jpeg',
            'assets/Images/Jaen.jpeg',
            'assets/Images/Almeria.jpg',
            'assets/Images/Estepona.jpg',
            'assets/Images/Sevilla.webp',
            'assets/Images/Cordoba.webp',
            'assets/Images/Huelva.jpg',
            'assets/Images/Malaga.jpg',
            'assets/Images/Almeria.jpg',
            'assets/Images/Granada.webp',
          ]),
          // Fotos etiquetadas
          GridViewWidget(imagePaths: [
            'assets/Images/Sevilla.webp',
            'assets/Images/Cordoba.webp',
            'assets/Images/Huelva.jpg',
            'assets/Images/Estepona.jpg',
            'assets/Images/Sevilla.webp',
            'assets/Images/Cordoba.webp',
            'assets/Images/Malaga.jpg',
            'assets/Images/Almeria.jpg',
            'assets/Images/Granada.webp',
            'assets/Images/Jaen.jpeg',
            'assets/Images/Almeria.jpg',
            'assets/Images/Estepona.jpg',
          ]),
        ],
      ),
    );
  }
}
