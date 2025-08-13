import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/repositories/task_repository.dart'; // Sesuaikan path

class UpdateTaskStatus {
  final TaskRepository repository;

  UpdateTaskStatus(this.repository);

  Future<Either<Failure, String>> call({
    required int id,
    required bool isCompleted,
  }) {
    return repository.updateTaskStatusById(id: id, isCompleted: isCompleted);
  }
}
