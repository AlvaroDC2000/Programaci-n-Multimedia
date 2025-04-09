
import 'package:flutter/material.dart';
import '../../drawer/drawer.dart';
import '../../routes/app_routes.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> listas = [
      {
        'titulo': 'Compra semanal',
        'descripcion': '7 elementos',
      },
      {
        'titulo': 'Tareas del proyecto',
        'descripcion': '4 tareas pendientes',
      },
      {
        'titulo': 'Viaje a Madrid',
        'descripcion': '5 preparativos',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF26C485),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          SizedBox(
            height: 180,
            child: Image.asset(
              'assets/Images/ListaYaLogo.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Drawer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),

          // Título
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Mis Listas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Listas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: listas.length,
              itemBuilder: (context, index) {
                final item = listas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(item['titulo'] ?? ''),
                    subtitle: Text(item['descripcion'] ?? ''),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.modify);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
