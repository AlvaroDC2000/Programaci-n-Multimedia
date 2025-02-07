import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthylife/main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../drawer/drawer.dart';

// Clase de la pantalla hidratación en ella guardamos los vasos de agua que bebemos al día y llevamos un registro
class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HydrationScreenState createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int consumedCups = 0;
  final int dailyGoal = 8; // Cantidad recomendada de vasos de agua
  DateTime today = DateTime.now();
  String hydrationTip = "";

  final List<String> hydrationTips = [
    "💧 Recuerda beber agua cada 2 horas.",
    "🏃‍♂️ ¡No olvides hidratarte después de hacer ejercicio!",
    "☀️ Si hace calor, bebe más agua para mantenerte fresco.",
    "🥤 Mantén una botella de agua cerca para beber con frecuencia.",
    "🌿 Una buena hidratación mejora tu energía y concentración.",
    "🚰 El agua ayuda a tu digestión y salud general.",
  ];

  @override
  void initState() {
    super.initState();
    _loadHydrationData();
    _generateHydrationTip();
  }

  /// Generar un consejo de hidratación aleatorio
  void _generateHydrationTip() {
    final random = Random();
    setState(() {
      hydrationTip = hydrationTips[random.nextInt(hydrationTips.length)];
    });
  }

  /// Cargar datos del día desde Firestore
  void _loadHydrationData() async {
    String todayDate = "${today.year}-${today.month}-${today.day}";

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('hydration_data').doc(todayDate).get();

      if (snapshot.exists) {
        setState(() {
          consumedCups = snapshot['cups'] ?? 0;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al cargar datos de hidratación: $e");
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al obtener los datos de hidratación")),
      );
    }
  }

//Añadir vaso de agua
  void _addCup() async {
    setState(() {
      consumedCups += 1;
    });

    String todayDate = "${today.year}-${today.month}-${today.day}";

    try {
      await _firestore.collection('hydration_data').doc(todayDate).set({
        'date': todayDate,
        'cups': consumedCups,
      });

      // ignore: duplicate_ignore
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Registro de agua guardado!")),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error al registrar vaso de agua: $e");
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al registrar vaso de agua")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidratación'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Consejo de Hidratación
            Card(
              color: Colors.blue[100],
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    hydrationTip,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Progreso de Hidratación
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Consumo Diario de Agua:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: consumedCups / dailyGoal,
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "$consumedCups vasos consumidos",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Registro de Vasos
            Center(
              child: ElevatedButton(
                onPressed: _addCup,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child:
                    const Text('Añadir Vaso', style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 30),

            /// Historial de Hidratación
            const Text(
              'Historial de Hidratación:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('hydration_data')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final hydrationHistory = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: hydrationHistory.length,
                    itemBuilder: (context, index) {
                      var record = hydrationHistory[index];
                      return Card(
                        child: ListTile(
                          leading:
                              const Icon(Icons.local_drink, color: Colors.blue),
                          title: Text('${record['cups']} vasos de agua'),
                          subtitle: Text('Fecha: ${record['date']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
