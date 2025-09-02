import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/repositories/task_repository.dart';
import 'package:task/domain/entities/task.dart' as entity;

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, String>> call(entity.Task task) {
    return repository.updateTask(task);
  }
}
