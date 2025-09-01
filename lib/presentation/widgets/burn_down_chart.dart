import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project/presentation/bloc/dashboard_stats/dashboard_stats_bloc.dart';

class BurnDownChart extends StatelessWidget {
  const BurnDownChart({super.key});

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
                  final data = stats?.burnDownData ?? [];
                  if (data.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.noData),
                    );
                  }
                  final now = DateTime.now();
                  final labels = List.generate(data.length, (index) {
                    final date = now.subtract(
                      Duration(days: data.length - 1 - index),
                    );
                    return DateFormat('E').format(date);
                  });
                  final spots = List.generate(
                    data.length,
                    (index) => FlSpot(index.toDouble(), data[index].toDouble()),
                  );
                  return LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
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
                            reservedSize: 32,
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
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
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
