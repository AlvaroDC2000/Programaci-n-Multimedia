import 'package:flutter/material.dart';
import 'base_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Recuperación de PMDM',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/Images/MartinCarpena.jpg', width: 200, height: 200),
          Text(
              'Martin Carpena',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          Text(
              'https://www.malagadeporteyeventos.com/instalaciones/palacio-de-deportes-jose-ma-martin-carpena/',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
