import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/domain/usecases/get_progress_log_stats.dart';

class ProgressLogChart extends StatelessWidget {
  final List<ProgressLog> logs;
  final GetProgressLogStats getStats;

  ProgressLogChart({
    super.key,
    required this.logs,
    GetProgressLogStats? getStats,
  }) : getStats = getStats ?? GetProgressLogStats();

  @override
  Widget build(BuildContext context) {
    final stats = getStats(logs);
    final entries = stats.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final barGroups = entries.asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: e.value.toDouble(),
            width: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final date = entries[value.toInt()].key;
                  final label = '${date.month}/${date.day}';
                  return Text(label, style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
