import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../drawer/drawer.dart';
import '../../main.dart';
import 'package:intl/intl.dart';

// Clase de pantalla ejercicio, en ella se introducen los pasos y distintos ejercicios que hagamos, y se guandan sus registros
class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int dailySteps = 0;
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _exerciseTypeController = TextEditingController();
  final TextEditingController _exerciseDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAndResetSteps();
  }

// Revisa y y resetea los pasos
  void _checkAndResetSteps() async {
  try {
    DocumentSnapshot snapshot =
        await _firestore.collection('exercise_data').doc('current_steps').get();

    if (snapshot.exists) {
      String lastSavedDate = snapshot['date'] ?? todayDate;

      if (lastSavedDate != todayDate) {
        // Guardar los pasos del día anterior en historial
        await _firestore.collection('step_history').doc(lastSavedDate).set({
          'date': lastSavedDate,
          'steps': dailySteps,
        });

        // Reiniciar pasos para el nuevo día
        setState(() {
          dailySteps = 0;
        });

        await _firestore.collection('exercise_data').doc('current_steps').set({
          'date': todayDate,
          'steps': 0,
        });
      } else {
        setState(() {
          dailySteps = snapshot['steps'] ?? 0;
        });
      }
    } else {
      await _firestore.collection('exercise_data').doc('current_steps').set({
        'date': todayDate,
        'steps': 0,
      });
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error al resetear pasos: $e");
    }
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al obtener los pasos del día")),
    );
  }
}

// Introduce los pasos manualmente
void _enterStepsManually() async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Añadir Pasos"),
      content: TextField(
        controller: _stepsController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: "Introduce los pasos"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              int enteredSteps = int.tryParse(_stepsController.text) ?? 0;
              setState(() {
                dailySteps = enteredSteps;
              });

              await _firestore.collection('exercise_data').doc('current_steps').set({
                'date': todayDate,
                'steps': dailySteps,
              });

              _stepsController.clear();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } catch (e) {
              if (kDebugMode) {
                print("Error al guardar los pasos: $e");
              }
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error al guardar los pasos")),
              );
            }
          },
          child: const Text("Guardar"),
        ),
      ],
    ),
  );
}

// Añade sesiones de ejercicios
void _addExerciseSession() async {
  if (_exerciseTypeController.text.isEmpty || _exerciseDurationController.text.isEmpty) return;

  try {
    await _firestore.collection('exercise_sessions').add({
      'type': _exerciseTypeController.text,
      'duration': _exerciseDurationController.text,
      'date': todayDate,
    });

    _exerciseTypeController.clear();
    _exerciseDurationController.clear();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sesión de ejercicio guardada con éxito")),
    );
  } catch (e) {
    if (kDebugMode) {
      print("Error al guardar sesión de ejercicio: $e");
    }
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al guardar la sesión de ejercicio")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///  PASOS DIARIOS
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pasos diarios:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$dailySteps pasos',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: _enterStepsManually,
                            child: const Text('Introducir Pasos'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ///  HISTORIAL DE PASOS
              const Text(
                'Historial de Pasos Diarios:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('step_history').orderBy('date', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final stepsHistory = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stepsHistory.length,
                    itemBuilder: (context, index) {
                      var stepData = stepsHistory[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.directions_walk, color: Colors.blue),
                          title: Text('${stepData['steps']} pasos'),
                          subtitle: Text('Fecha: ${stepData['date']}'),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              ///  REGISTRO DE EJERCICIO
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registrar Ejercicio:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _exerciseTypeController,
                        decoration: const InputDecoration(labelText: 'Tipo de ejercicio'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _exerciseDurationController,
                        decoration: const InputDecoration(labelText: 'Duración (minutos)'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: _addExerciseSession,
                          child: const Text('Guardar Sesión'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ///  HISTORIAL DE EJERCICIOS
              const Text(
                'Historial de Ejercicios:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('exercise_sessions').orderBy('date', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final exerciseHistory = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exerciseHistory.length,
                    itemBuilder: (context, index) {
                      var session = exerciseHistory[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.fitness_center, color: Colors.green),
                          title: Text(session['type']),
                          subtitle: Text('Duración: ${session['duration']} min'),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
