import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Nueva columna para agregar un nuevo destacado
            Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[300],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(height: 4),
                      Text('Nuevo', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text('Nuevo', style: GoogleFonts.robotoCondensed()),
              ],
            ),
            const SizedBox(width: 12),
            const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/Images/Malaga.jpg'),
                ),
                SizedBox(height: 8),
                Text('Málaga'),
              ],
            ),
            const SizedBox(width: 12),
            const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/Images/Granada.webp'),
                ),
                SizedBox(height: 8),
                Text('Granada'),
              ],
            ),
            const SizedBox(width: 12),
            const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/Images/Cadiz.jpeg'),
                ),
                SizedBox(height: 8),
                Text('Cádiz'),
              ],
            ),
            const SizedBox(width: 12),
            const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/Images/Jaen.jpeg'),
                ),
                SizedBox(height: 8),
                Text('Jaén'),
              ],
            ),
            const SizedBox(width: 12),
            const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/Images/Almeria.jpg'),
                ),
                SizedBox(height: 8),
                Text('Almería'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
