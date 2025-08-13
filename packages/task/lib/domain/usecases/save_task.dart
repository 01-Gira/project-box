import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/repositories/task_repository.dart';
import 'package:task/domain/entities/task.dart' as entity;

class SaveTask {
  final TaskRepository repository;
  SaveTask(this.repository);

  Future<Either<Failure, String>> call({
    required int projectId,
    required entity.Task task,
  }) {
    return repository.saveTask(projectId: projectId, task: task);
  }
}
