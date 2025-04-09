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
              color: Color.fromARGB(255, 54, 180, 111),
            ),
            child: Text('Menú de navegación'),
          ),
          ListTile(
            title: const Text('Mis Listas'),
            onTap: () {
              Navigator.pushNamed(context, '/lists');
            },
          ),
          ListTile(
            title: const Text('Listas Completadas'),
            onTap: () {
              Navigator.pushNamed(context, '/finished');
            },
          ),
          ListTile(
            title: const Text('Crear Lista'),
            onTap: () {
              Navigator.pushNamed(context, '/task');
            },
          ),
          ListTile(
            title: const Text('Cuenta'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: const Text('Ajustes'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
