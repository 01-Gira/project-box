import 'package:core/common/exception.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:task/data/models/task_table.dart';
import 'package:task/data/models/task_with_project_info_table.dart';

abstract class TaskLocalDataSource {
  Future<String> insertTask({required int projectId, required TaskTable task});

  Future<String> removeTask(int id);
  Future<List<TaskTable>> getTasksForProject(int id);
  Future<String> updateTasksOrder(List<TaskTable> task);
  Future<String> updateTaskById({required int id, required String title});
  Future<String> updateTaskStatusById({
    required int id,
    required bool isCompleted,
  });
  Future<List<TaskWithProjectInfoTable>> getNextTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper helper;

  TaskLocalDataSourceImpl({required this.helper});

  @override
  Future<List<TaskTable>> getTasksForProject(int id) async {
    try {
      final result = await helper.getTasksForProject(id);
      return result.map((data) => TaskTable.fromMap(data)).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> insertTask({
    required int projectId,
    required TaskTable task,
  }) async {
    try {
      await helper.insertTask(projectId, task.toJson());

      return 'Added to project';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> updateTaskById({
    required int id,
    required String title,
  }) async {
    try {
      await helper.updateTask(id, title);
      return 'Task updated';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> updateTaskStatusById({
    required int id,
    required bool isCompleted,
  }) async {
    try {
      await helper.updateTaskStatus(id, isCompleted);
      return 'Task updated';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTask(int id) async {
    try {
      await helper.deleteTask(id);

      return 'Removed from project';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> updateTasksOrder(List<TaskTable> tasks) async {
    try {
      await helper.updateTasksOrder(tasks);

      return 'Tasks order has been updated';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<TaskWithProjectInfoTable>> getNextTasks() async {
    final result = await helper.getNextTasks(limit: 3);
    return result
        .map((data) => TaskWithProjectInfoTable.fromMap(data))
        .toList();
  }
}
