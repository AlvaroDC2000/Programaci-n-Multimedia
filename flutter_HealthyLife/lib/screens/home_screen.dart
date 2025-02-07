import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../drawer/drawer.dart';
import '../main.dart';
import 'dart:math';

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
            Text('Resumen Diario',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard(context, 'Agua', '$waterGlasses vasos',
                    Icons.water_drop, Colors.blue),
                _buildSummaryCard(context, 'Ejercicio', '$steps pasos',
                    Icons.fitness_center, Colors.green),
                _buildSummaryCard(context, 'Sueño', '$sleepHours horas',
                    Icons.bedtime, Colors.purple),
              ],
            ),
            const SizedBox(height: 30),
            _buildStepProgressChart(),
            const SizedBox(height: 30),
            _buildSleepProgressChart(weeklySleep),
            const SizedBox(height: 30),
            Text('Consejo Diario',
                style: Theme.of(context).textTheme.titleLarge),
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
            Text('Retos Semanales',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...weeklyChallenges.map((challenge) => ListTile(
                  title: Text(challenge),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String data,
      IconData icon, Color iconColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 5),
            Text(data,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  /// Gráfico de pasos semanales
  Widget _buildStepProgressChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pasos Semanales",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Container(
          height: 250,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ],
          ),
          child: weeklySteps.isEmpty ||
                  (weeklySteps.length == 1 && weeklySteps[0].y == 0)
              ? const Center(child: Text("No hay datos disponibles"))
              : LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}k',
                                style: const TextStyle(fontSize: 12));
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < weeklySteps.length) {
                              return Text("Día ${index + 1}",
                                  style: const TextStyle(fontSize: 12));
                            }
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    gridData: const FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: weeklySteps,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    minX: 0, // Asegurar que el eje X comienza en 0
                    maxX: weeklySteps.length > 1
                        ? weeklySteps.length.toDouble() - 1
                        : 1, // Ajuste en la escala X
                  ),
                ),
        ),
      ],
    );
  }

// Grafico de progreso de sueño semanal
  Widget _buildSleepProgressChart(dynamic weeklySleepHours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Horas de Sueño Semanales",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Container(
          height: 250,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ],
          ),
          child: weeklySleepHours.isEmpty ||
                  (weeklySleepHours.length == 1 && weeklySleepHours[0].y == 0)
              ? const Center(child: Text("No hay datos disponibles"))
              : LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}h',
                                style: const TextStyle(fontSize: 12));
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < weeklySleepHours.length) {
                              return Text("Día ${index + 1}",
                                  style: const TextStyle(fontSize: 12));
                            }
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    gridData: const FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: weeklySleepHours,
                        isCurved: true,
                        color: Colors.purple,
                        barWidth: 4,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    minX: 0,
                    maxX: weeklySleepHours.length > 1
                        ? weeklySleepHours.length.toDouble() - 1
                        : 1,
                  ),
                ),
        ),
      ],
    );
  }
}
