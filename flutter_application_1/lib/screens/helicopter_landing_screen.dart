import 'package:flutter/material.dart';
import 'base_screen.dart';

class HelicopterLandingScreen extends StatelessWidget {
  const HelicopterLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Zona de Aterrizaje para Helicópteros',
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.orange,
              width: 10,
            ),
          ),
          width: 280,
          height: 280,
          alignment: Alignment.center,
          child: const Text(
            'H',
            style: TextStyle(
              fontSize: 180,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}
