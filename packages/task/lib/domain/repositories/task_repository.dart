import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/entities/task.dart' as entity;
import 'package:task/domain/entities/task_with_project_info.dart';

abstract class TaskRepository {
  Future<Either<Failure, String>> saveTask({
    required int projectId,
    required entity.Task task,
  });
  Future<Either<Failure, String>> removeTaskById(int id);
  Future<Either<Failure, List<entity.Task>>> getTasksForProject(int id);
  Future<Either<Failure, String>> updateTasksOrder(List<entity.Task> tasks);
  Future<Either<Failure, String>> updateTask(entity.Task task);
  Future<Either<Failure, String>> updateTaskStatusById({
    required int id,
    required bool isCompleted,
  });
  Future<Either<Failure, List<TaskWithProjectInfo>>> getNextTasks();
}
