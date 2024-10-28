import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Personal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Álvaro Díaz Casaño',
              style: GoogleFonts.lobster(
                textStyle: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Dirección del Repositorio: https://github.com/AlvaroDC2000/Programación-Multimedia',
              style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
