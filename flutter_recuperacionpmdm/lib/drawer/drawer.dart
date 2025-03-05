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
            title: const Text('Página Principal'),
            onTap: () {
              Navigator.pushNamed(context, '/main');
            },
          ),
          ListTile(
            title: const Text('Página Final'),
            onTap: () {
              Navigator.pushNamed(context, '/final');
            },
          ),
        ],
      ),
    );
  }
}
