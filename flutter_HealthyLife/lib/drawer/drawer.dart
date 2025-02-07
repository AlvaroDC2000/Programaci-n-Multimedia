import 'package:flutter/material.dart';

// Clase del drawer
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
          //Pantalla inicial
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          //Pantalla hidratación
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Hidratación'),
            onTap: () {
              Navigator.pushNamed(context, '/hydration');
            },
          ),
          // Pantalla ejercicio
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Ejercicio'),
            onTap: () {
              Navigator.pushNamed(context, '/exercise');
            },
          ),
          //Pantalla sueño
          ListTile(
            leading: const Icon(Icons.bedtime),
            title: const Text('Sueño'),
            onTap: () {
              Navigator.pushNamed(context, '/sleep');
            },
          ),
          //Pantalla dieta
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Dietas'),
            onTap: () {
              Navigator.pushNamed(context, '/diet');
            },
          ),
          //Pantalla Configuración
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          //Pantalla perfil
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
