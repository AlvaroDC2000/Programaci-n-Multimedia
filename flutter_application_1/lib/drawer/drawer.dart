import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menú de navegación'),
          ),
          ListTile(
            title: const Text('Página de Inicio'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            title: const Text('Página de Información Personal'),
            onTap: () {
              Navigator.pushNamed(context, '/personal_info');
            },
          ),
          ListTile(
            title: const Text('Imágenes en Fila'),
            onTap: () {
              Navigator.pushNamed(context, '/row_images');
            },
          ),
          ListTile(
            title: const Text('Imágenes en Columna'),
            onTap: () {
              Navigator.pushNamed(context, '/column_images');
            },
          ),
          ListTile(
            title: const Text('Mostrar iconos'),
            onTap: () {
              Navigator.pushNamed(context, '/icons');
            },
          ),
          ListTile(
            title: const Text('Helicópteros'),
            onTap: () {
              Navigator.pushNamed(context, '/helicopters');
            },
          ),
          ListTile(
            title: const Text('Disposición Compleja'),
            onTap: () {
              Navigator.pushNamed(context, '/complex_layout');
            },
          ),
          ListTile(
            title: const Text('Contador de clicks'),
            onTap: () {
              Navigator.pushNamed(context, '/counter');
            },
          ),
          ListTile(
            title: const Text('Instagram'),
            onTap: () {
              Navigator.pushNamed(context, '/instagram');
            },
          ),
          ListTile(
            title: const Text('Filas y Columnas Anidadas'),
            onTap: () {
              Navigator.pushNamed(context, '/nested_rows_columns');
            },
          ),
          ListTile(
            title: const Text('Juego de Imágenes'),
            onTap: () {
              Navigator.pushNamed(context, '/game_screen');
            },
          ),
          ListTile(
            title: const Text('Juego de Siete y Media'),
            onTap: () {
              Navigator.pushNamed(context, '/siete_y_media');
            },
          ),
        ],
      ),
    );
  }
}
