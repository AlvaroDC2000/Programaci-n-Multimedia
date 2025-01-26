import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../drawer/drawer.dart';
import '../main.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomeScreen({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> dailyTips = [
    'Bebe al menos 8 vasos de agua al día.',
    'Realiza ejercicio durante 30 minutos.',
    'Evita las pantallas antes de dormir.',
    'Incluye frutas y verduras en tu dieta.',
    'Mantén un horario regular de sueño.'
  ];

  String currentTip = 'Bebe al menos 8 vasos de agua al día.';

  void changeTip() {
    setState(() {
      final random = Random();
      currentTip = dailyTips[random.nextInt(dailyTips.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthyLife'),
        backgroundColor: const Color(0xFF81C784),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumen Diario',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/hidration_screen'),
                    child: _buildSummaryCard(context, 'Agua', '8 vasos', Icons.water_drop, Colors.blue),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/exercise_screen'),
                    child: _buildSummaryCard(context, 'Ejercicio', '8000 pasos', Icons.fitness_center, Colors.green),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/sleep_screen'),
                    child: _buildSummaryCard(context, 'Sueño', '7 horas', Icons.bedtime, Colors.purple),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Progreso Semanal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _buildProgressChart(),
              const SizedBox(height: 30),
              Text(
                'Retos de Ejercicio',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildExerciseChallenges(),
              const SizedBox(height: 30),
              Text(
                'Consejo Diario',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: changeTip,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          currentTip,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Últimos Logros',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildAchievementsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String data, IconData icon, Color iconColor) {
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
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 5),
            Text(
              data,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseChallenges() {
    final challenges = [
      'Camina 10,000 pasos',
      'Corre durante 20 minutos',
      'Haz 50 sentadillas',
      'Realiza 15 minutos de yoga',
      'Sube escaleras durante 5 minutos'
    ];

    return Column(
      children: challenges.map((challenge) {
        return ListTile(
          leading: const Icon(Icons.directions_run, color: Colors.green),
          title: Text(challenge),
        );
      }).toList(),
    );
  }

  Widget _buildProgressChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Gráfico en desarrollo',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    final achievements = [
      'Primer día completando 10,000 pasos.',
      'Bebiste 8 vasos de agua durante 3 días consecutivos.',
      'Dormiste 7 horas durante toda la semana pasada.'
    ];

    return Column(
      children: achievements.map((achievement) {
        return ListTile(
          leading: const Icon(Icons.star, color: Colors.amber),
          title: Text(achievement),
        );
      }).toList(),
    );
  }
}

