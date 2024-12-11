import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiographySection extends StatelessWidget {
  const BiographySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Álvaro Díaz Casaño', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
          Text('Rey Tortuga', style: GoogleFonts.lato()),
          const SizedBox(height: 8),
          Text('www.picasso.com', style: GoogleFonts.lato(color: Colors.blue)),
        ],
      ),
    );
  }
}
