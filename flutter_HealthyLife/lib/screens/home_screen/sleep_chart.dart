import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

//Clase para la widget de horas de sueño semanales
class SleepChart extends StatelessWidget {
  final List<FlSpot> weeklySleepHours;

  const SleepChart({super.key, required this.weeklySleepHours});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Horas de Sueño Semanales", style: Theme.of(context).textTheme.titleLarge),
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
          child: weeklySleepHours.isEmpty || (weeklySleepHours.length == 1 && weeklySleepHours[0].y == 0)
              ? const Center(child: Text("No hay datos disponibles"))
              : LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}h', style: const TextStyle(fontSize: 12));
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
                        spots: weeklySleepHours,
                        isCurved: true,
                        color: Colors.purple,
                        barWidth: 4,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    minX: 0,
                    maxX: weeklySleepHours.length > 1 ? weeklySleepHours.length.toDouble() - 1 : 1,
                  ),
                ),
        ),
      ],
    );
  }
}
