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
              color:  Color(0xFF81C784),
            ),
            child: Text(
              'HealthyLife - Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Hidratación'),
            onTap: () {
              Navigator.pushNamed(context, '/hydration');
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Ejercicio'),
            onTap: () {
              Navigator.pushNamed(context, '/exercise');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bedtime),
            title: const Text('Sueño'),
            onTap: () {
              Navigator.pushNamed(context, '/sleep');
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Dietas'),
            onTap: () {
              Navigator.pushNamed(context, '/diet');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
