import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/enitites/dashboard_stats.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/enitites/project_with_progress.dart';

abstract class ProjectRepository {
  Future<Either<Failure, String>> editProject({
    required int id,
    required Project project,
  });
  Future<Either<Failure, String>> saveProject(Project project);
  Future<Either<Failure, String>> removeProjectById(int id);
  Future<Either<Failure, List<Project>>> getProjects({int? limit});
  Future<Either<Failure, Project>> getProjectById(int id);
  Future<Either<Failure, List<ProjectWithProgress>>> getProjectWithProgress({
    int? limit,
  });
  Future<Either<Failure, DashboardStats>> getDashboardStats();
  Future<Either<Failure, String>> updateProjectsStatus(
    List<int> ids,
    String newStatus,
  );
  Future<Either<Failure, String>> removeProjects(List<int> ids);
}
