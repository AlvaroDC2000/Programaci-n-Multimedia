import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget buildDrawerTile({
    required IconData icon,
    required String title,
    required void Function() onTap,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final color =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black87;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: theme.hoverColor,
        splashColor: theme.splashColor,
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.grey[800];
    final iconColor = isDark ? Colors.white70 : Colors.grey;

    return Drawer(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 40, 120, 80)
                    : const Color.fromARGB(255, 54, 180, 111),
              ),
              child: const Row(
                children: [
                  Icon(Icons.list_alt, color: Colors.white, size: 40),
                  SizedBox(width: 10),
                  Text(
                    'ListaYa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerTile(
                    icon: Icons.view_list,
                    title: 'Mis Listas',
                    onTap: () => Navigator.pushNamed(context, '/lists'),
                    context: context,
                  ),
                  buildDrawerTile(
                    icon: Icons.done_all,
                    title: 'Listas Completadas',
                    onTap: () => Navigator.pushNamed(context, '/finished'),
                    context: context,
                  ),
                  buildDrawerTile(
                    icon: Icons.add,
                    title: 'Crear Lista',
                    onTap: () => Navigator.pushNamed(context, '/task'),
                    context: context,
                  ),
                  const Divider(),
                  buildDrawerTile(
                    icon: Icons.person,
                    title: 'Cuenta',
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                    context: context,
                  ),
                  buildDrawerTile(
                    icon: Icons.settings,
                    title: 'Ajustes',
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                    context: context,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      '¡Organiza tu vida con ListaYa!',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Icon(
                      Icons.article,
                      size: 60,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
