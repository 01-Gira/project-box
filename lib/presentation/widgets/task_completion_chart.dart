import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project/presentation/bloc/dashboard_stats/dashboard_stats_bloc.dart';

class TaskCompletionChart extends StatelessWidget {
  const TaskCompletionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: BlocBuilder<DashboardStatsBloc, DashboardStatsState>(
            builder: (context, state) {
              switch (state.state) {
                case RequestState.loading:
                  return const Center(child: CircularProgressIndicator());
                case RequestState.error:
                  return Center(child: Text(state.message));
                case RequestState.loaded:
                  final stats = state.stats;
                  final data = stats?.dailyTaskCompletions ?? [];
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.noData,
                        ),
                      );
                    }
                  final now = DateTime.now();
                  final labels = List.generate(data.length, (index) {
                    final date = now.subtract(
                      Duration(days: data.length - 1 - index),
                    );
                    return DateFormat('E').format(date);
                  });
                  final barGroups = List.generate(data.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data[index].toDouble(),
                          width: 14,
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    );
                  });
                  return BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= labels.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  labels[index],
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            },
                            reservedSize: 32,
                          ),
                        ),
                      ),
                      barGroups: barGroups,
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
