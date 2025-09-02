import 'package:core/common/exception.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/notification_service.dart';
import 'package:task/data/models/task_table.dart';
import 'package:task/data/models/task_with_project_info_table.dart';

abstract class TaskLocalDataSource {
  Future<String> insertTask({required int projectId, required TaskTable task});

  Future<String> removeTask(int id);
  Future<List<TaskTable>> getTasksForProject(int id);
  Future<String> updateTasksOrder(List<TaskTable> task);
  Future<String> updateTask(TaskTable task);
  Future<String> updateTaskStatusById({
    required int id,
    required bool isCompleted,
  });
  Future<List<TaskWithProjectInfoTable>> getNextTasks();
  Future<List<TaskWithProjectInfoTable>> searchTasks({
    String? query,
    int? dueDate,
    bool? isCompleted,
  });
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper helper;
  final NotificationService notificationService;

  TaskLocalDataSourceImpl({
    required this.helper,
    required this.notificationService,
  });

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
      final id = await helper.insertTask(projectId, task.toJson());
      if (task.dueDate != null) {
        await notificationService.scheduleTaskReminder(
          id: id,
          title: task.title,
          scheduledTime: DateTime.fromMillisecondsSinceEpoch(task.dueDate!),
        );
      }
      return 'Added to project';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> updateTask(TaskTable task) async {
    try {
      await helper.updateTask(task.id, task.toJson());
      if (task.dueDate != null) {
        await notificationService.scheduleTaskReminder(
          id: task.id,
          title: task.title,
          scheduledTime: DateTime.fromMillisecondsSinceEpoch(task.dueDate!),
        );
      } else {
        await notificationService.cancelTaskReminder(task.id);
      }
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

  @override
  Future<List<TaskWithProjectInfoTable>> searchTasks({
    String? query,
    int? dueDate,
    bool? isCompleted,
  }) async {
    final db = await helper.database;
    if (db == null) return [];

    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (query != null && query.isNotEmpty) {
      where.add('T.title LIKE ?');
      whereArgs.add('%' + query + '%');
    }

    if (dueDate != null) {
      final date = DateTime.fromMillisecondsSinceEpoch(dueDate);
      final start = DateTime(
        date.year,
        date.month,
        date.day,
      ).millisecondsSinceEpoch;
      final end = start + const Duration(days: 1).inMilliseconds;
      where.add('T.due_date >= ? AND T.due_date < ?');
      whereArgs
        ..add(start)
        ..add(end);
    }

    if (isCompleted != null) {
      where.add('T.is_completed = ?');
      whereArgs.add(isCompleted ? 1 : 0);
    }

    final whereClause = where.isNotEmpty ? 'WHERE ' + where.join(' AND ') : '';

    final result = await db.rawQuery('''
      SELECT
        T.id,
        T.title,
        T.is_completed,
        T.order_sequence,
        T.due_date,
        T.priority,
        T.description,
        T.parent_task_id,
        T.recurrence_rule,
        T.recurrence_end_date,
        T.project_id,
        P.name as project_name
      FROM tasks T
      INNER JOIN projects P ON T.project_id = P.id
      $whereClause
      ORDER BY T.due_date ASC, T.priority DESC
      ''', whereArgs);

    return result
        .map((data) => TaskWithProjectInfoTable.fromMap(data))
        .toList();
  }
}
