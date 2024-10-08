import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Principal());
}

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Drawer Demo'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menú de navegación'),
              ),
              // Usamos un Builder para asegurarnos que tenemos el contexto correcto
              Builder(
                builder: (context) {
                  return ListTile(
                    title: const Text('Página de Información Personal'),
                    onTap: () {
                      Navigator.of(context).pop(); // Cierra el Drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PersonalInfoScreen()),
                      );
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return ListTile(
                    title: const Text('Imágenes en Fila'),
                    onTap: () {
                      Navigator.of(context).pop(); // Cierra el Drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RowImagesScreen()),
                      );
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return ListTile(
                    title: const Text('Imágenes en Columna'),
                    onTap: () {
                      Navigator.of(context).pop(); // Cierra el Drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ColumnImagesScreen()),
                      );
                    },
                  );
                },
              ),
              Builder(
                builder: (context) {
                  return ListTile(
                    title: const Text('Mostrar Iconos'),
                    onTap: () {
                      Navigator.of(context).pop(); // Cierra el Drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IconsScreen()),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: const Center(child: Text("Selecciona una opción del Drawer")),
      ),
    );
  }
}

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Personal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Álvaro Díaz Casaño',
              style: GoogleFonts.lobster(
                textStyle: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Dirección del Repositorio: https://github.com/AlvaroDC2000/Programaci-n-Multimedia',
              style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowImagesScreen extends StatelessWidget {
  const RowImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imágenes en Fila'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('lib/assets/Images/Malaga.jpg', width: 200, height: 200),
          Image.asset('lib/assets/Images/Granada.webp', width: 200, height: 200),
          Image.asset('lib/assets/Images/Cadiz.jpeg', width: 200, height: 200),
        ],
      ),
    );
  }
}

class ColumnImagesScreen extends StatelessWidget {
  const ColumnImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imágenes en Columna'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/assets/Images/Malaga.jpg', width: 200, height: 200),
          const SizedBox(height: 10),
          Image.asset('lib/assets/Images/Granada.webp', width: 200, height: 200),
          const SizedBox(height: 10),
          Image.asset('lib/assets/Images/Cadiz.jpeg', width: 200, height: 200),
        ],
      ),
    );
  }
}

class IconsScreen extends StatelessWidget {
  const IconsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mostrar Iconos'),
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, size: 50, color: Colors.blue),
          Icon(Icons.star, size: 50, color: Colors.yellow),
          Icon(Icons.favorite, size: 50, color: Colors.red),
          Icon(Icons.person, size: 50, color: Colors.green),
          Icon(Icons.settings, size: 50, color: Colors.purple),
        ],
      ),
    );
  }
}


