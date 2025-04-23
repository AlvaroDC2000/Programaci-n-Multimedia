import 'package:flutter/material.dart';
import '../../drawer/drawer.dart';

class FinishedScreen extends StatelessWidget {
  const FinishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> listasFinalizadas = [
      {
        'titulo': 'Mudanza',
        'fecha': '01/04/2025',
      },
      {
        'titulo': 'Regalos de Navidad',
        'fecha': '25/12/2024',
      },
      {
        'titulo': 'Preparar exposición',
        'fecha': '17/03/2025',
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

          // Botón 
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
                'Listas Completadas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Lista finalizada
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: listasFinalizadas.length,
              itemBuilder: (context, index) {
                final lista = listasFinalizadas[index];
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
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(lista['titulo'] ?? ''),
                    subtitle: Text('Finalizada el ${lista['fecha']}'),
                    trailing: const Icon(Icons.check),
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

