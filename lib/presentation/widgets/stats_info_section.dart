import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/presentation/bloc/dashboard_stats/dashboard_stats_bloc.dart';

class StatsInfoSection extends StatelessWidget {
  const StatsInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: BlocBuilder<DashboardStatsBloc, DashboardStatsState>(
          builder: (context, state) {
            switch (state.state) {
              case RequestState.loading:
                return const Center(child: CircularProgressIndicator());
              case RequestState.error:
                return Center(child: Text(state.message));
              case RequestState.loaded:
                final stats = state.stats;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      Icons.check_circle_outline,
                      stats?.completedProjects.toString() ?? '0',
                      AppLocalizations.of(context)!.finishedProjects,
                    ),
                    _buildStatItem(
                      context,
                      Icons.local_fire_department_outlined,
                      stats?.productiveStreak.toString() ?? '0',
                      AppLocalizations.of(context)!.productiveDay,
                    ),
                    _buildStatItem(
                      context,
                      Icons.task_alt_outlined,
                      stats?.totalTasksDone.toString() ?? '0',
                      AppLocalizations.of(context)!.finishedTasks,
                    ),
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, color: colorScheme.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
