import 'package:flutter/material.dart';
import 'base_screen.dart';
import 'instagram/profile_section.dart';
import 'instagram/biography_section.dart';
import 'instagram/edit_profile_button.dart';
import 'instagram/highlights_section.dart';
import 'instagram/tab_bar.dart';
import 'instagram/tab_bar_view.dart';

class InstagramScreen extends StatelessWidget {
  const InstagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: BaseScreen(
        title: 'alvaroD00',
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
