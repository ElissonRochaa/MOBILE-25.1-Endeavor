import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/evolucao_model.dart';

class SimpleBarChart extends StatelessWidget {
  final List<EvolucaoModel> evolucao;
  final bool animate;
  final List<String> labels;

  const SimpleBarChart({
    super.key,
    required this.evolucao,
    required this.animate,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: evolucao.isEmpty ? 1 : evolucao.map((e) => e.tempo).reduce((a, b) => a > b ? a : b).toDouble() + 1,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                  return Text(
                    labels[idx],
                    style: const TextStyle(fontSize: 12),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: evolucao.asMap().entries.map((entry) {
            int idx = entry.key;
            int tempo = entry.value.tempo;
            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: tempo.toDouble(),
                  color: Colors.blueAccent,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
