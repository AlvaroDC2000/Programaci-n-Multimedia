import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/complex_layout_screen.dart';
import 'package:flutter_application_1/screens/counter_screen.dart';
import 'package:flutter_application_1/screens/instagram_screen.dart';
import 'package:flutter_application_1/screens/nested_rows_columns.dart';
import '../screens/personal_info_screen.dart';
import '../screens/row_images_screen.dart';
import '../screens/column_images_screen.dart';
import '../screens/icons_screen.dart';
import '../screens/helicopter_landing_screen.dart';

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
            title: const Text('Página de Información Personal'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PersonalInfoScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Imágenes en Fila'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RowImagesScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Imágenes en Columna'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ColumnImagesScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Mostrar iconos'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const IconsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Helicópteros'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HelicopterLandingScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Disposición Compleja'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ComplexLayoutScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Contador de clicks'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CounterScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Instagram'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InstagramScreen()),
              );
            },
          ),
          ListTile(
                title: const Text('Filas y Columnas Anidadas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NestedRowsColumnsScreen(),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
