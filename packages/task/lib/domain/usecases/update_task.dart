import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, String>> call({
    required int id,
    required String title,
  }) {
    return repository.updateTaskById(id: id, title: title);
  }
}
