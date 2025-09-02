import 'package:core/common/exception.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:project/data/models/project_table.dart';
import 'package:project/data/models/project_with_progress_table.dart';

abstract class ProjectLocalDataSource {
  Future<String> insertProject(ProjectTable project);
  Future<String> editProject({required int id, required ProjectTable project});
  Future<String> removeProject(int id);
  Future<List<ProjectTable>> getProjects(int? limit);
  Future<ProjectTable> getProjectById(int id);
  Future<List<ProjectWithProgressTable>> getProjectsWithProgress(int? limit);
  Future<Map<String, dynamic>> getDashboardStats();
  Future<String> updateProjectsStatus(List<int> ids, String newStatus);
  Future<String> removeProjects(List<int> ids);
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final DatabaseHelper helper;

  ProjectLocalDataSourceImpl({required this.helper});

  @override
  Future<ProjectTable> getProjectById(int id) async {
    try {
      final result = await helper.getProjectById(id);
      return ProjectTable.fromMap(result);
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<ProjectTable>> getProjects(int? limit) async {
    try {
      final result = await helper.getProjectWithProgress(limit);
      return result.map((data) => ProjectTable.fromMap(data)).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> insertProject(ProjectTable project) async {
    try {
      await helper.insertProject(project.toJson());

      return 'Added to project';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> editProject({
    required int id,
    required ProjectTable project,
  }) async {
    try {
      await helper.updateProject(id, project.toJson());
      return 'Project updated';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeProject(int id) async {
    try {
      await helper.deleteProject(id);

      return 'Removed from project';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<ProjectWithProgressTable>> getProjectsWithProgress(
    int? limit,
  ) async {
    try {
      final result = await helper.getProjectWithProgress(limit);
      return result
          .map((data) => ProjectWithProgressTable.fromMap(data))
          .toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      return await helper.getDashboardStats();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> updateProjectsStatus(List<int> ids, String newStatus) async {
    try {
      await helper.updateProjectsStatus(ids, newStatus);
      return 'Successfully updated status projects';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeProjects(List<int> ids) async {
    try {
      await helper.removeProjects(ids);
      return 'Successfully deleted  projects';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
