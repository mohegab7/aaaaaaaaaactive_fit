import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutrientChart extends StatelessWidget {
  final Map<String, double> nutrients;

  const NutrientChart({super.key, required this.nutrients});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      nutrients.keys.elementAt(value.toInt()),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: nutrients.entries.map((entry) {
            return BarChartGroupData(
              x: nutrients.keys.toList().indexOf(entry.key),
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.lightBlue.shade200,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }
}