import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_section.dart';
import 'biography_section.dart';
import 'edit_profile_button.dart';
import 'highlights_section.dart';
import 'tab_bar.dart';
import 'tab_bar_view.dart';

class InstagramScreen extends StatelessWidget {
  const InstagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'alvaroD00',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: const [
            Icon(Icons.menu, color: Colors.black),
            SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  // Perfil
                  ProfileSection(),
                  // Biografía
                  BiographySection(),
                  SizedBox(height: 16),
                  // Botón de editar perfil
                  EditProfileButton(),
                  SizedBox(height: 16),
                  // Historias destacadas
                  HighlightsSection(),
                  SizedBox(height: 16),
                  // TabBar para alternar entre fotos publicadas y etiquetadas
                  TabBarWidget(),
                  // Contenedor para mostrar las fotos según la pestaña seleccionada
                  TabBarViewWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
