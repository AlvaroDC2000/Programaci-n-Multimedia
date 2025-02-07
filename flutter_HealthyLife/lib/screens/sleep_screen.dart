import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthylife/main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../drawer/drawer.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _hoursController = TextEditingController();
  DateTime today = DateTime.now();
  String sleepTip = "";

  final List<String> sleepTips = [
    "😴 Evita las pantallas 30 minutos antes de dormir.",
    "🕒 Mantén un horario constante para acostarte.",
    "🏃‍♂️ Haz ejercicio regularmente, pero no antes de dormir.",
    "🌙 Asegúrate de que tu habitación esté oscura y silenciosa.",
    "☕ Evita la cafeína por la tarde o noche.",
    "📖 Leer un libro antes de dormir puede ayudarte a relajarte.",
    "🛏️ Usa tu cama solo para dormir, no para trabajar o ver TV.",
  ];

  @override
  void initState() {
    super.initState();
    _generateSleepTip();
  }

  /// **Generar un consejo de sueño aleatorio**
  void _generateSleepTip() {
    final random = Random();
    setState(() {
      sleepTip = sleepTips[random.nextInt(sleepTips.length)];
    });
  }

  /// **Registrar horas de sueño**
  void _addSleepHours() async {
  if (_hoursController.text.isEmpty) return;

  int hours = int.tryParse(_hoursController.text) ?? 0;
  if (hours <= 0) return;

  String todayDate = "${today.year}-${today.month}-${today.day}";

  try {
    await _firestore.collection('sleep_data').doc(todayDate).set({
      'date': todayDate,
      'hours': hours,
    });

    _hoursController.clear();
    setState(() {});
  } catch (e) {
    if (kDebugMode) {
      print("Error al guardar los datos en Firestore: $e");
    }
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al guardar los datos en Firestore")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sueño'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Consejo sobre sueño**
            Card(
              color: Colors.purple[100],
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    sleepTip,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// **Registro de horas de sueño**
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registra tus horas de sueño:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _hoursController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Horas dormidas',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _addSleepHours,
                          child: const Text('Añadir'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// **Historial de sueño**
            const Text(
              'Historial de Sueño:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('sleep_data').orderBy('date', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final sleepHistory = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: sleepHistory.length,
                    itemBuilder: (context, index) {
                      var record = sleepHistory[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.bedtime, color: Colors.purple),
                          title: Text('${record['hours']} horas de sueño'),
                          subtitle: Text('Fecha: ${record['date']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// **Consejos para un mejor sueño**
            const Text(
              'Consejos para un mejor sueño:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.lightbulb, color: Colors.orange),
                    title: Text('Evita las pantallas 30 minutos antes de dormir.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.timer, color: Colors.orange),
                    title: Text('Mantén un horario constante para ir a dormir.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.fitness_center, color: Colors.orange),
                    title: Text('Haz ejercicio regularmente, pero evita hacerlo antes de dormir.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.bedtime, color: Colors.orange),
                    title: Text('Asegúrate de que tu habitación esté oscura y silenciosa.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_drink, color: Colors.orange),
                    title: Text('Evita consumir cafeína por la tarde o noche.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
