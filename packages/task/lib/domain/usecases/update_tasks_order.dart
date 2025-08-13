import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/repositories/task_repository.dart';
import 'package:task/domain/entities/task.dart' as entity;

class UpdateTasksOrder {
  final TaskRepository repository;

  UpdateTasksOrder(this.repository);

  Future<Either<Failure, String>> call(List<entity.Task> tasks) {
    return repository.updateTasksOrder(tasks);
  }
}
