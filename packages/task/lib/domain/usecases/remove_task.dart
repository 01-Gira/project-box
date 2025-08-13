import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/repositories/task_repository.dart';

class RemoveTask {
  final TaskRepository repository;
  RemoveTask(this.repository);

  Future<Either<Failure, String>> call(int projectId) {
    return repository.removeTaskById(projectId);
  }
}
