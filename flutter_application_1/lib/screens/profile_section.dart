import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/Images/perfil.jpg'),
          ),
          Column(
            children: [
              Text('30', style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Publicaciones', style: GoogleFonts.robotoCondensed()),
            ],
          ),
          Column(
            children: [
              Text('60M', style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Seguidores', style: GoogleFonts.robotoCondensed()),
            ],
          ),
          Column(
            children: [
              Text('180', style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Siguiendo', style: GoogleFonts.robotoCondensed()),
            ],
          ),
        ],
      ),
    );
  }
}
