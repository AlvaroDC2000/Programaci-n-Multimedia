import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../drawer/drawer.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _diets = [];
  List<Map<String, dynamic>> _registeredMeals = [];
  List<Map<String, dynamic>> _favoriteDiets = []; // **Lista de favoritas**
  String _selectedDietType = "vegetarian";
  bool _isLoading = false;

  final List<String> _dietTypes = [
    "vegetarian",
    "keto",
    "low-carb",
    "mediterranean",
    "vegan",
    "paleo",
  ];

  @override
  void initState() {
    super.initState();
    _fetchDiets();
    _fetchRegisteredMeals();
    _fetchFavoriteDiets(); // **Cargar favoritas**
  }

  /// **Obtener las dietas de la API**
  Future<void> _fetchDiets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
          "https://api.edamam.com/api/recipes/v2?type=public&q=$_selectedDietType&app_id=d8ac0b23&app_key=d3efb430b4d710c05df7706b8965c4aa");

      final response = await http.get(
        url,
        headers: {"Edamam-Account-User": "alvaropicasso"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('hits')) {
          setState(() {
            _diets = List<Map<String, dynamic>>.from(
                data['hits'].map((hit) => hit['recipe']));
          });
        } else {
          throw Exception("Respuesta inesperada de la API");
        }
      } else {
        throw Exception("Error en la API: Código ${response.statusCode}");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar dietas: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// **Abrir la URL de la receta**
  Future<void> _openRecipeUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  /// **Guardar dieta en favoritos en Firestore**
  void _saveFavoriteDiet(Map<String, dynamic> diet) async {
    try {
      await _firestore.collection('favorite_diets').add({
        'label': diet['label'],
        'url': diet['url'],
        'dietType': _selectedDietType,
        'date': DateTime.now().toString(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dieta guardada en favoritos")),
      );

      _fetchFavoriteDiets(); // **Actualizar la lista**
    } catch (e) {
      if (kDebugMode) {
        print("Error al guardar dieta: $e");
      }
    }
  }

  /// **Registrar una comida en Firestore**
  void _registerMeal(String mealName) async {
    try {
      await _firestore.collection('meals').add({
        'name': mealName,
        'date': DateTime.now().toString(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comida registrada correctamente")),
      );

      _fetchRegisteredMeals(); // **Actualizar lista de comidas registradas**
    } catch (e) {
      if (kDebugMode) {
        print("Error al registrar comida: $e");
      }
    }
  }

  /// **Obtener comidas registradas de Firestore**
  Future<void> _fetchRegisteredMeals() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('meals')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        _registeredMeals = snapshot.docs.map((doc) {
          return {
            'name': doc['name'],
            'date': doc['date'],
          };
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener comidas registradas: $e");
      }
    }
  }

  /// **Obtener dietas favoritas de Firestore**
  Future<void> _fetchFavoriteDiets() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('favorite_diets')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        _favoriteDiets = snapshot.docs.map((doc) {
          return {
            'name': doc['label'],
            'url': doc['url'],
            'date': doc['date'],
          };
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener dietas favoritas: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dietas'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar por tipo de dieta:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedDietType,
                items: _dietTypes.map((String diet) {
                  return DropdownMenuItem<String>(
                    value: diet,
                    child: Text(diet.toUpperCase()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDietType = newValue!;
                  });
                  _fetchDiets();
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 300, // Ajusta la altura según sea necesario
                      child: ListView.builder(
                        itemCount: _diets.length,
                        itemBuilder: (context, index) {
                          final diet = _diets[index];
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(diet['label']),
                              subtitle: Row(
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        _openRecipeUrl(diet['url']),
                                    child: const Text("Abrir receta"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        _registerMeal(diet['label']),
                                    child: const Text("Registrar comida"),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.favorite,
                                    color: Colors.red),
                                onPressed: () => _saveFavoriteDiet(diet),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 20),
              const Text(
                'Historial de comidas registradas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200, // Ajusta según el contenido
                child: ListView.builder(
                  itemCount: _registeredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = _registeredMeals[index];
                    return ListTile(
                      title: Text(meal['name']),
                      subtitle: Text("Fecha: ${meal['date']}"),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Historial de dietas favoritas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200, // Ajusta según el contenido
                child: ListView.builder(
                  itemCount: _favoriteDiets.length,
                  itemBuilder: (context, index) {
                    final fav = _favoriteDiets[index];
                    return ListTile(
                      title: Text(fav['name']),
                      subtitle: Text("Fecha: ${fav['date']}"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}