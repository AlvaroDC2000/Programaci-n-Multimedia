import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../drawer/drawer.dart';
import '../../main.dart';
import 'dart:math';
import '../home_screen/summary_card.dart';
import '../home_screen/step_chart.dart' as step;
import '../home_screen/sleep_chart.dart' as sleep;

// Clase de la pantalla principal, en ella podremos ver el resumen diario, los progresos semanales, obtendremos consejos y nos propone retos
class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomeScreen(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> dailyTips = [
    'Bebe al menos 8 vasos de agua al día.',
    'Realiza ejercicio durante 30 minutos.',
    'Evita las pantallas antes de dormir.',
    'Incluye frutas y verduras en tu dieta.',
    'Mantén un horario regular de sueño.'
  ];
  final List<String> weeklyChallenges = [
    'Camina 50,000 pasos en una semana.',
    'Corre al menos 3 días esta semana.',
    'Duerme al menos 7 horas cada noche.',
    'Bebe 2 litros de agua todos los días.',
    'Evita el azúcar refinado durante una semana.'
  ];

  String currentTip = 'Bebe al menos 8 vasos de agua al día.';

  int steps = 0;
  int waterGlasses = 0;
  int sleepHours = 0;
  List<FlSpot> weeklySteps = [];
  List<FlSpot> weeklySleep = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _fetchDailyData();
    _fetchWeeklySteps();
    _fetchWeeklySleep();
  }

  /// Carga la configuración desde Firestore
  void _loadSettings() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('settings').doc('user_settings').get();

      if (snapshot.exists) {
        // ignore: use_build_context_synchronously
        final appSettings = Provider.of<AppSettings>(context, listen: false);
        setState(() {
          bool isDarkMode = snapshot['theme'] == "dark";
          double fontSize = (snapshot['fontSize'] ?? 16.0).toDouble();
          String fontStyle = snapshot['fontStyle'] ?? 'Roboto';

          appSettings.setFontSize(fontSize);
          appSettings.setFontStyle(fontStyle);

          if (isDarkMode != appSettings.isDarkMode) {
            appSettings.toggleTheme();
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al cargar configuración en HomeScreen: $e");
      }
    }
  }

  /// Obtiene datos diarios de Firestore
  void _fetchDailyData() async {
    try {
      DocumentSnapshot stepSnapshot = await _firestore
          .collection('exercise_data')
          .doc('current_steps')
          .get();

      if (stepSnapshot.exists) {
        setState(() {
          steps = stepSnapshot['steps'] ?? 0;
        });
      }

      QuerySnapshot hydrationSnapshot = await _firestore
          .collection('hydration_data')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (hydrationSnapshot.docs.isNotEmpty) {
        setState(() {
          waterGlasses = hydrationSnapshot.docs.first['cups'] ?? 0;
        });
      }

      QuerySnapshot sleepSnapshot = await _firestore
          .collection('sleep_data')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (sleepSnapshot.docs.isNotEmpty) {
        setState(() {
          sleepHours = sleepSnapshot.docs.first['hours'] ?? 0;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener datos diarios: $e");
      }
    }
  }

  /// Obtiene los pasos semanales desde Firestore
  void _fetchWeeklySteps() async {
    try {
      QuerySnapshot stepSnapshot = await _firestore
          .collection('step_history') // Asegurar la colección correcta
          .orderBy('date', descending: false) // Ordenar cronológicamente
          .limit(7) // Obtener los últimos 7 días
          .get();

      List<FlSpot> data = [];
      List<String> labels = [];

      int index = 0;
      for (var doc in stepSnapshot.docs) {
        String date = doc['date']; // Fecha en formato "YYYY-MM-DD"
        int stepCount = doc['steps'] ?? 0;

        labels.add(date.substring(5)); // Solo MM-DD para mostrarlo más corto
        data.add(FlSpot(index.toDouble(), stepCount / 1000)); // Pasos en miles

        index++;
      }

      setState(() {
        weeklySteps = data.isNotEmpty ? data : [const FlSpot(0, 0)];
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener pasos semanales: $e");
      }
    }
  }

  /// Obtiene las horas de sueño semanales desde Firestore
  void _fetchWeeklySleep() async {
    try {
      QuerySnapshot stepSnapshot = await _firestore
          .collection('sleep_data') // Asegurar la colección correcta
          .orderBy('date', descending: false) // Ordenar cronológicamente
          .limit(7) // Obtener los últimos 7 días
          .get();

      List<FlSpot> data = [];
      List<String> labels = [];

      int index = 0;
      for (var doc in stepSnapshot.docs) {
        String date = doc['date']; // Fecha en formato "YYYY-MM-DD"
        int hoursCount = doc['hours'] ?? 0;

        labels.add(date.substring(7)); // Solo MM-DD para mostrarlo más corto
        data.add(FlSpot(index.toDouble(), hoursCount / 1)); // Pasos en miles

        index++;
      }

      setState(() {
        weeklySleep = data.isNotEmpty ? data : [const FlSpot(0, 0)];
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener horas de sueño semanales: $e");
      }
    }
  }

  void changeTip() {
    setState(() {
      final random = Random();
      currentTip = dailyTips[random.nextInt(dailyTips.length)];
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('HealthyLife'),
          backgroundColor: const Color(0xFF81C784)),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen Diario', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SummaryCard(title: 'Agua', data: '$waterGlasses vasos', icon: Icons.water_drop, iconColor: Colors.blue),
                SummaryCard(title: 'Ejercicio', data: '$steps pasos', icon: Icons.fitness_center, iconColor: Colors.green),
                SummaryCard(title: 'Sueño', data: '$sleepHours horas', icon: Icons.bedtime, iconColor: Colors.purple),
              ],
            ),
            const SizedBox(height: 30),
            step.StepChart(weeklySteps: weeklySteps),
            const SizedBox(height: 30),
            sleep.SleepChart(weeklySleepHours: weeklySleep),
            const SizedBox(height: 30),
            Text('Consejo Diario', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: changeTip,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(currentTip,
                            style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text('Retos Semanales', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...weeklyChallenges.map((challenge) => ListTile(title: Text(challenge))),
          ],
        ),
      ),
    );
  }
}