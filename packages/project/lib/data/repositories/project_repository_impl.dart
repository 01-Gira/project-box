import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/enitites/dashboard_stats.dart';
import 'package:project/domain/enitites/project_with_progress.dart';
import 'package:project/domain/repositories/project_repository.dart';
import 'package:project/data/datasources/project_local_data_source.dart';
import 'package:project/data/models/project_table.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:core/analytics/analytics_service.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource localDataSource;
  final AnalyticsService analyticsService;

  ProjectRepositoryImpl({
    required this.localDataSource,
    required this.analyticsService,
  });

  @override
  Future<Either<Failure, List<Project>>> getProjects({int? limit}) async {
    try {
      final result = await localDataSource.getProjects(limit);
      return Right(result.map((data) => data.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeProjectById(int id) async {
    try {
      final result = await localDataSource.removeProject(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveProject(Project project) async {
    try {
      final projectTable = ProjectTable.fromEntity(project);
      final result = await localDataSource.insertProject(projectTable);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> editProject({
    required int id,
    required Project project,
  }) async {
    try {
      final projectTable = ProjectTable.fromEntity(project);
      final result = await localDataSource.editProject(
        id: id,
        project: projectTable,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Project>> getProjectById(int id) async {
    try {
      final result = await localDataSource.getProjectById(id);
      return Right(result.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProjectWithProgress>>> getProjectWithProgress({
    int? limit,
  }) async {
    try {
      final result = await localDataSource.getProjectsWithProgress(limit);
      return Right(result.map((data) => data.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats() async {
    try {
      final result = await localDataSource.getDashboardStats();
      final daily = (result['dailyTaskCompletions'] as List<dynamic>? ?? [])
          .cast<int>();
      final totalTasks = result['totalTasks'] as int? ?? 0;
      final burnDown = analyticsService.calculateBurnDown(totalTasks, daily);
      final velocity = analyticsService.calculateVelocity(daily);
      // Ubah Map menjadi Entitas
      return Right(
        DashboardStats(
          completedProjects: result['completedProjects'] ?? 0,
          totalTasksDone: result['totalTasksDone'] ?? 0,
          productiveStreak: result['productiveStreak'] ?? 0,
          dailyTaskCompletions: daily,
          burnDownData: burnDown,
          velocity: velocity,
        ),
      );
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateProjectsStatus(
    List<int> ids,
    String newStatus,
  ) async {
    try {
      await localDataSource.updateProjectsStatus(ids, newStatus);
      return Right('${ids.length} proyek berhasil diperbarui');
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> removeProjects(List<int> ids) async {
    try {
      await localDataSource.removeProjects(ids);
      return Right('${ids.length} proyek berhasil dihapus');
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
