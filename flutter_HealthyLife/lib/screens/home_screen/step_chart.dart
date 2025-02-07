import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

//Clase para la widget pasos semanales
class StepChart extends StatelessWidget {
  final List<FlSpot> weeklySteps;

  const StepChart({super.key, required this.weeklySteps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pasos Semanales", style: Theme.of(context).textTheme.titleLarge),
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
                blurRadius: 5,
              )
            ],
          ),
          child: weeklySteps.isEmpty || (weeklySteps.length == 1 && weeklySteps[0].y == 0)
              ? const Center(child: Text("No hay datos disponibles"))
              : LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}k', style: const TextStyle(fontSize: 12));
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
                              return Text("Día ${index + 1}", style: const TextStyle(fontSize: 12));
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
                    minX: 0,
                    maxX: weeklySteps.length > 1 ? weeklySteps.length.toDouble() - 1 : 1,
                  ),
                ),
        ),
      ],
    );
  }
}
