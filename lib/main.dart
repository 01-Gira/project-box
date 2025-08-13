import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_log/domain/usecases/get_progress_log.dart';
import 'package:progress_log/presentation/bloc/create_progress_log/create_progress_log_bloc.dart';
import 'package:progress_log/presentation/bloc/get_progress_logs/get_progress_logs_for_project_bloc.dart';
import 'package:progress_log/presentation/bloc/remove_progress_log/remove_progress_log_bloc.dart';
import 'package:progress_log/presentation/bloc/update_progress_log/update_progress_log_bloc.dart';
import 'package:project/domain/usecases/get_dashboard_stats.dart';
import 'package:project/domain/usecases/get_project_items.dart';
import 'package:project/presentation/bloc/create_project/create_project_bloc.dart';
import 'package:project/presentation/bloc/dashboard_stats/dashboard_stats_bloc.dart';
import 'package:project/presentation/bloc/edit_project/edit_project_bloc.dart';
import 'package:project/presentation/bloc/get_project_by_id/get_project_by_id_bloc.dart';
import 'package:project/presentation/bloc/get_project_items/get_project_items_bloc.dart';
import 'package:project/presentation/bloc/remove_project_by_id/remove_project_by_id_bloc.dart';
import 'package:project/presentation/bloc/remove_projects/remove_projects_bloc.dart';
import 'package:project/presentation/bloc/update_projects_status/update_projects_status_bloc.dart';
import 'package:project_box/app_theme.dart';
import 'package:project_box/injection.dart' as di;
import 'package:project_box/router/app_router.dart';
import 'package:task/domain/usecases/get_next_tasks.dart';
import 'package:task/domain/usecases/get_tasks_for_project.dart';
import 'package:task/presentation/bloc/create_task/create_task_bloc.dart';
import 'package:task/presentation/bloc/get_tasks_for_project/get_tasks_for_project_bloc.dart';
import 'package:task/presentation/bloc/next_tasks/next_tasks_bloc.dart';
import 'package:task/presentation/bloc/remove_task/remove_task_bloc.dart';
import 'package:task/presentation/bloc/update_task/update_task_bloc.dart';
import 'package:task/presentation/bloc/update_task_status/update_task_status_bloc.dart';
import 'package:task/presentation/bloc/update_tasks_order/update_tasks_order_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<GetProjectByIdBloc>()),
        BlocProvider(create: (_) => di.locator<CreateProjectBloc>()),
        BlocProvider(create: (_) => di.locator<EditProjectBloc>()),
        BlocProvider(create: (_) => di.locator<RemoveProjectByIdBloc>()),
        BlocProvider(create: (_) => di.locator<RemoveProjectsBloc>()),
        BlocProvider(create: (_) => di.locator<UpdateProjectsStatusBloc>()),

        BlocProvider(create: (_) => di.locator<CreateTaskBloc>()),
        BlocProvider(create: (_) => di.locator<UpdateTasksOrderBloc>()),
        BlocProvider(create: (_) => di.locator<RemoveTaskBloc>()),
        BlocProvider(create: (_) => di.locator<UpdateTaskBloc>()),
        BlocProvider(create: (_) => di.locator<UpdateTaskStatusBloc>()),
        BlocProvider(
          create: (context) => GetTasksForProjectBloc(
            getTasksForProject: di.locator<GetTasksForProject>(),
            createaskStatusBloc: context.read<CreateTaskBloc>(),
            updateTaskStatusBloc: context.read<UpdateTaskStatusBloc>(),
            updateTaskBloc: context.read<UpdateTaskBloc>(),
            removeTaskBloc: context.read<RemoveTaskBloc>(),
            updateTasksOrderBloc: context.read<UpdateTasksOrderBloc>(),
          ),
        ),

        BlocProvider(create: (_) => di.locator<CreateProgressLogBloc>()),
        BlocProvider(create: (_) => di.locator<RemoveProgressLogBloc>()),
        BlocProvider(create: (_) => di.locator<UpdateProgressLogBloc>()),
        BlocProvider(
          create: (context) => NextTasksBloc(
            getNextTasks: di.locator<GetNextTasks>(),
            editProjectBloc: context.read<EditProjectBloc>(),
            removeProjectByIdBloc: context.read<RemoveProjectByIdBloc>(),
            createTaskBloc: context.read<CreateTaskBloc>(),
            updateTaskStatusBloc: context.read<UpdateTaskStatusBloc>(),
            updateTaskBloc: context.read<UpdateTaskBloc>(),
            removeTaskBloc: context.read<RemoveTaskBloc>(),
            updateTasksOrderBloc: context.read<UpdateTasksOrderBloc>(),
          ),
        ),

        BlocProvider(
          create: (context) => GetProgressLogsForProjectBloc(
            getProgressLog: di.locator<GetProgressLog>(),
            createProgressLogBloc: context
                .read<CreateProgressLogBloc>(), // <-- Ambil dari context
            removeProgressLogBloc: context
                .read<RemoveProgressLogBloc>(), // <-- Ambil dari context
            updateProgressLogBloc: context
                .read<UpdateProgressLogBloc>(), // <-- Ambil dari context
          ),
        ),

        BlocProvider(
          create: (context) => GetProjectItemsBloc(
            getProjectItems: di.locator<GetProjectItems>(),
            createProjectBloc: context.read<CreateProjectBloc>(),
            editProjectBloc: context.read<EditProjectBloc>(),
            removeProjectByIdBloc: context.read<RemoveProjectByIdBloc>(),
            updateProjectsStatusBloc: context.read<UpdateProjectsStatusBloc>(),
            removeProjectsBloc: context.read<RemoveProjectsBloc>(),
            updateTaskStatusBloc: context.read<UpdateTaskStatusBloc>(),
            updateTaskBloc: context.read<UpdateTaskBloc>(),
            removeTaskBloc: context.read<RemoveTaskBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) => DashboardStatsBloc(
            getDashboardStats: di.locator<GetDashboardStats>(),
            editProjectBloc: context.read<EditProjectBloc>(),
            removeProjectByIdBloc: context.read<RemoveProjectByIdBloc>(),
            updateTaskStatusBloc: context.read<UpdateTaskStatusBloc>(),
            removeTaskBloc: context.read<RemoveTaskBloc>(),
          ),
        ),
      ],
      child: AppWithRouter(),
    );
  }
}

class AppWithRouter extends StatelessWidget {
  const AppWithRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Project BOX',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter().router,
    );
  }
}
