import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Instagram());
}

class Instagram extends StatelessWidget {
  const Instagram({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2, // Número de pestañas
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'alvaroD00',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: const [
              Icon(Icons.menu, color: Colors.black),
              SizedBox(width: 16),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // Perfil
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('lib/assets/Images/perfil.jpg'),
                          ),
                          Column(
                            children: [
                              Text('30', style: GoogleFonts.robotoCondensed(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Publicaciones', style: GoogleFonts.robotoCondensed()),
                            ],
                          ),
                          Column(
                            children: [
                              Text('60M', style: GoogleFonts.robotoCondensed(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Seguidores', style: GoogleFonts.robotoCondensed()),
                            ],
                          ),
                          Column(
                            children: [
                              Text('180', style: GoogleFonts.robotoCondensed(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Siguiendo', style: GoogleFonts.robotoCondensed()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Biografía
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Álvaro Díaz Casaño',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rey Tortuga',
                            style: GoogleFonts.lato(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'www.picasso.com',
                            style: GoogleFonts.lato(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Botón de editar perfil
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // Esto hace el botón rectangular
                            ),
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            'Editar Perfil',
                            style: GoogleFonts.lato(),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Historias destacadas
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey[300],
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.black),
                                      SizedBox(height: 4),
                                      Text(
                                        'Nuevo',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Nuevo', style: GoogleFonts.robotoCondensed()),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage('lib/assets/Images/Malaga.jpg'),
                                ),
                                SizedBox(height: 8),
                                Text('Málaga'),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage('lib/assets/Images/Granada.webp'),
                                ),
                                SizedBox(height: 8),
                                Text('Granada'),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage('lib/assets/Images/Estepona.jpg'),
                                ),
                                SizedBox(height: 8),
                                Text('Estepona'),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage('lib/assets/Images/Huelva.jpg'),
                                ),
                                SizedBox(height: 8),
                                Text('Huelva'),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage('lib/assets/Images/Cadiz.jpeg'),
                                ),
                                SizedBox(height: 8),
                                Text('Cádiz'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // TabBar para alternar entre fotos publicadas y etiquetadas
                    const TabBar(
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(icon: Icon(Icons.grid_on)),
                        Tab(icon: Icon(Icons.person_pin)),
                      ],
                    ),
                    // Contenedor para mostrar las fotos según la pestaña seleccionada
                    SizedBox(
                      height: 300, // Ajustar si es necesario
                      child: TabBarView(
                        children: [
                          // Fotos publicadas
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            itemCount: 12, // Número de fotos publicadas
                            itemBuilder: (context, index) {
                              List<String> imagePaths = [
                                'lib/assets/Images/Malaga.jpg',
                                'lib/assets/Images/Granada.webp',
                                'lib/assets/Images/Cadiz.jpeg',
                                'lib/assets/Images/Jaen.jpeg',
                                'lib/assets/Images/Almeria.jpg',
                                'lib/assets/Images/Estepona.jpg',
                                'lib/assets/Images/Sevilla.webp',
                                'lib/assets/Images/Cordoba.webp',
                                'lib/assets/Images/Huelva.jpg',
                                'lib/assets/Images/Malaga.jpg',
                                'lib/assets/Images/Almeria.jpg',
                                'lib/assets/Images/Granada.webp',
                              ];
                              return Container(
                                color: Colors.grey[300],
                                child: Image.asset(
                                  imagePaths[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                          // Fotos etiquetadas
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            itemCount: 12, // Número de fotos etiquetadas
                            itemBuilder: (context, index) {
                              List<String> taggedImagePaths = [
                                'lib/assets/Images/Sevilla.webp',
                                'lib/assets/Images/Cordoba.webp',
                                'lib/assets/Images/Huelva.jpg',
                                'lib/assets/Images/Estepona.jpg',
                                'lib/assets/Images/Sevilla.webp',
                                'lib/assets/Images/Cordoba.webp',
                                'lib/assets/Images/Malaga.jpg',
                                'lib/assets/Images/Almeria.jpg',
                                'lib/assets/Images/Granada.webp',
                                'lib/assets/Images/Jaen.jpeg',
                                'lib/assets/Images/Almeria.jpg',
                                'lib/assets/Images/Estepona.jpg',
                              ];
                              return Container(
                                color: Colors.grey[300],
                                child: Image.asset(
                                  taggedImagePaths[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}