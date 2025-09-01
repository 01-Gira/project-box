import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/data/datasources/task_local_data_source.dart';
import 'package:task/data/models/task_table.dart';
import 'package:task/domain/entities/task.dart' as entity;
import 'package:task/domain/entities/task_with_project_info.dart';

import 'package:task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<entity.Task>>> getTasksForProject(int id) async {
    try {
      final result = await localDataSource.getTasksForProject(id);
      return Right(result.map((data) => data.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeTaskById(int id) async {
    try {
      final result = await localDataSource.removeTask(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> updateTask(entity.Task task) async {
    try {
      final result = await localDataSource.updateTask(
        TaskTable.fromEntity(task),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> updateTaskStatusById({
    required int id,
    required bool isCompleted,
  }) async {
    try {
      final result = await localDataSource.updateTaskStatusById(
        id: id,
        isCompleted: isCompleted,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveTask({
    required int projectId,
    required entity.Task task,
  }) async {
    try {
      final taskTable = TaskTable.fromEntity(task);
      final result = await localDataSource.insertTask(
        projectId: projectId,
        task: taskTable,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> updateTasksOrder(
    List<entity.Task> tasks,
  ) async {
    try {
      final List<TaskTable> taskTables = tasks
          .map((task) => TaskTable.fromEntity(task))
          .toList();
      final result = await localDataSource.updateTasksOrder(taskTables);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TaskWithProjectInfo>>> getNextTasks() async {
    try {
      final result = await localDataSource.getNextTasks();
      // Ubah List<Model> menjadi List<Entity>
      return Right(result.map((model) => model.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskWithProjectInfo>>> searchTasks({
    String? query,
    DateTime? dueDate,
    bool? isCompleted,
  }) async {
    try {
      final result = await localDataSource.searchTasks(
        query: query,
        dueDate: dueDate?.millisecondsSinceEpoch,
        isCompleted: isCompleted,
      );
      return Right(result.map((model) => model.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
