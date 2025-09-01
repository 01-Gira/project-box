import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/presentation/bloc/dashboard_stats/dashboard_stats_bloc.dart';
import 'package:project/presentation/bloc/get_project_items/get_project_items_bloc.dart';
import 'package:project_box/presentation/widgets/banner_images.dart';
import 'package:project_box/presentation/widgets/home_header.dart';
import 'package:project_box/presentation/widgets/next_task_section.dart';
import 'package:project_box/presentation/widgets/recent_projects.dart';
import 'package:project_box/presentation/widgets/stats_info_section.dart';
import 'package:project_box/presentation/widgets/task_completion_chart.dart';
import 'package:task/presentation/bloc/next_tasks/next_tasks_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<GetProjectItemsBloc>().add(FetchProjectItems(limit: 5));
        context.read<NextTasksBloc>().add(FetchNextTasks());
        context.read<DashboardStatsBloc>().add(FetchDashboardStats());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // HomeHeader(),
            // const SizedBox(height: 16),
            BannerImages(height: 180),
            const SizedBox(height: 16),
            const StatsInfoSection(),
            const SizedBox(height: 16),
            const TaskCompletionChart(),
            const SizedBox(height: 16),
            NextTaskSection(),
            const SizedBox(height: 16),
            RecentProjectsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/project/create');
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        tooltip: l10n.createProjectTitle,
        child: const Icon(Icons.add),
      ),
    );
  }
}
