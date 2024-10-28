import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Hace el botón rectangular
            ),
            foregroundColor: Colors.black,
          ),
          child: Text(
            'Editar Perfil',
            style: GoogleFonts.lato(),
          ),
        ),
      ),
    );
  }
}
