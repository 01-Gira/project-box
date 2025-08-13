import 'package:core/data/datasources/db/database_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:progress_log/data/datasources/progress_log_local_data_source.dart';
import 'package:progress_log/data/repositories/progress_log_repository_impl.dart';
import 'package:progress_log/domain/repositories/progress_log_repository.dart';
import 'package:progress_log/domain/usecases/get_progress_log.dart';
import 'package:progress_log/domain/usecases/remove_progress_log.dart';
import 'package:progress_log/domain/usecases/save_progress_log.dart';
import 'package:progress_log/domain/usecases/update_progress_log.dart';
import 'package:progress_log/presentation/bloc/create_progress_log/create_progress_log_bloc.dart';
import 'package:progress_log/presentation/bloc/get_progress_logs/get_progress_logs_for_project_bloc.dart';
import 'package:progress_log/presentation/bloc/remove_progress_log/remove_progress_log_bloc.dart';
import 'package:progress_log/presentation/bloc/update_progress_log/update_progress_log_bloc.dart';
import 'package:project/data/datasources/project_local_data_source.dart';
import 'package:project/data/repositories/project_repository_impl.dart';
import 'package:project/domain/repositories/project_repository.dart';
import 'package:project/domain/usecases/get_dashboard_stats.dart';
import 'package:project/domain/usecases/get_project_by_id.dart';

import 'package:project/domain/usecases/get_project_items.dart';
import 'package:project/domain/usecases/remove_project.dart';
import 'package:project/domain/usecases/remove_projects.dart';
import 'package:project/domain/usecases/save_project.dart';
import 'package:project/domain/usecases/edit_project.dart';
import 'package:project/domain/usecases/update_projects_status.dart';
import 'package:project/presentation/bloc/dashboard_stats/dashboard_stats_bloc.dart';
import 'package:project/presentation/bloc/edit_project/edit_project_bloc.dart';

import 'package:project/presentation/bloc/get_project_by_id/get_project_by_id_bloc.dart';

import 'package:project/presentation/bloc/create_project/create_project_bloc.dart';
import 'package:project/presentation/bloc/get_project_items/get_project_items_bloc.dart';
import 'package:project/presentation/bloc/remove_project_by_id/remove_project_by_id_bloc.dart';
import 'package:project/presentation/bloc/remove_projects/remove_projects_bloc.dart';
import 'package:project/presentation/bloc/update_projects_status/update_projects_status_bloc.dart';
import 'package:task/data/datasources/task_local_data_source.dart';
import 'package:task/data/repositories/task_repository_impl.dart';
import 'package:task/domain/repositories/task_repository.dart';
import 'package:task/domain/usecases/get_next_tasks.dart';
import 'package:task/domain/usecases/get_tasks_for_project.dart';
import 'package:task/domain/usecases/save_task.dart';
import 'package:task/domain/usecases/remove_task.dart';
import 'package:task/domain/usecases/update_task.dart';
import 'package:task/domain/usecases/update_task_status.dart';

import 'package:task/domain/usecases/update_tasks_order.dart';
import 'package:task/presentation/bloc/create_task/create_task_bloc.dart';
import 'package:task/presentation/bloc/get_tasks_for_project/get_tasks_for_project_bloc.dart';
import 'package:task/presentation/bloc/next_tasks/next_tasks_bloc.dart';
import 'package:task/presentation/bloc/remove_task/remove_task_bloc.dart';
import 'package:task/presentation/bloc/update_task/update_task_bloc.dart';
import 'package:task/presentation/bloc/update_task_status/update_task_status_bloc.dart';
import 'package:task/presentation/bloc/update_tasks_order/update_tasks_order_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Use Case
  // Project
  locator.registerLazySingleton(() => GetProjectById(locator()));
  locator.registerLazySingleton(() => GetProjectItems(locator()));
  locator.registerLazySingleton(() => SaveProject(locator()));
  locator.registerLazySingleton(() => EditProject(locator()));
  locator.registerLazySingleton(() => RemoveProject(locator()));
  locator.registerLazySingleton(() => RemoveProjects(locator()));
  locator.registerLazySingleton(() => UpdateProjectsStatus(locator()));

  locator.registerLazySingleton(() => GetDashboardStats(locator()));

  // Task
  locator.registerLazySingleton(() => GetTasksForProject(locator()));
  locator.registerLazySingleton(() => SaveTask(locator()));
  locator.registerLazySingleton(() => UpdateTasksOrder(locator()));
  locator.registerLazySingleton(() => RemoveTask(locator()));
  locator.registerLazySingleton(() => UpdateTask(locator()));
  locator.registerLazySingleton(() => UpdateTaskStatus(locator()));
  locator.registerLazySingleton(() => GetNextTasks(locator()));

  // Log
  locator.registerLazySingleton(() => GetProgressLog(locator()));
  locator.registerLazySingleton(() => SaveProgressLog(locator()));
  locator.registerLazySingleton(() => UpdateProgressLog(locator()));
  locator.registerLazySingleton(() => RemoveProgressLog(locator()));

  // Bloc
  // Project
  locator.registerFactory(() => GetProjectByIdBloc(locator()));
  locator.registerFactory(() => CreateProjectBloc(locator()));
  locator.registerFactory(() => EditProjectBloc(locator()));
  locator.registerFactory(() => RemoveProjectByIdBloc(locator()));
  locator.registerFactory(() => RemoveProjectsBloc(locator()));
  locator.registerFactory(() => UpdateProjectsStatusBloc(locator()));

  locator.registerFactory(
    () => GetProjectItemsBloc(
      getProjectItems: locator(),
      createProjectBloc: locator(),
      editProjectBloc: locator(),
      removeProjectByIdBloc: locator(),
      updateProjectsStatusBloc: locator(),
      removeProjectsBloc: locator(),
      updateTaskStatusBloc: locator(),
      updateTaskBloc: locator(),
      removeTaskBloc: locator(),
    ),
  );
  locator.registerFactory(
    () => DashboardStatsBloc(
      getDashboardStats: locator(),
      editProjectBloc: locator(),
      removeProjectByIdBloc: locator(),
      updateTaskStatusBloc: locator(),
      removeTaskBloc: locator(),
    ),
  );

  // Task
  locator.registerFactory(() => CreateTaskBloc(locator(), locator()));
  locator.registerFactory(() => UpdateTasksOrderBloc(locator()));
  locator.registerFactory(() => RemoveTaskBloc(locator()));
  locator.registerFactory(() => UpdateTaskBloc(locator()));
  locator.registerFactory(() => UpdateTaskStatusBloc(locator()));

  locator.registerFactory(
    () => GetTasksForProjectBloc(
      getTasksForProject: locator(),
      createaskStatusBloc: locator(),
      updateTaskStatusBloc: locator(),
      updateTaskBloc: locator(),
      removeTaskBloc: locator(),
      updateTasksOrderBloc: locator(),
    ),
  );

  locator.registerFactory(
    () => NextTasksBloc(
      getNextTasks: locator(),
      editProjectBloc: locator(),
      removeProjectByIdBloc: locator(),
      createTaskBloc: locator(),
      updateTaskStatusBloc: locator(),
      updateTaskBloc: locator(),
      removeTaskBloc: locator(),
      updateTasksOrderBloc: locator(),
    ),
  );

  // Log
  locator.registerFactory(() => CreateProgressLogBloc(locator()));
  locator.registerFactory(() => UpdateProgressLogBloc(locator()));
  locator.registerFactory(() => RemoveProgressLogBloc(locator()));

  locator.registerFactory(
    () => GetProgressLogsForProjectBloc(
      getProgressLog: locator(),
      createProgressLogBloc: locator(),
      updateProgressLogBloc: locator(),
      removeProgressLogBloc: locator(),
    ),
  );

  // Repository
  // Project
  locator.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(localDataSource: locator()),
  );
  // task
  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: locator()),
  );
  // Log
  locator.registerLazySingleton<ProgressLogRepository>(
    () => ProgressLogRepositoryImpl(localDataSource: locator()),
  );

  // Datasource
  // Project
  locator.registerLazySingleton<ProjectLocalDataSource>(
    () => ProjectLocalDataSourceImpl(helper: locator()),
  );
  // task
  locator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(helper: locator()),
  );
  // Log
  locator.registerLazySingleton<ProgressLogLocalDataSource>(
    () => ProgressLogLocalDataSourceImpl(helper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
