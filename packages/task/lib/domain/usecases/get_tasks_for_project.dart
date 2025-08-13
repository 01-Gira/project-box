import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/repositories/task_repository.dart';
import 'package:task/domain/entities/task.dart' as entity;

class GetTasksForProject {
  final TaskRepository repository;
  GetTasksForProject(this.repository);

  Future<Either<Failure, List<entity.Task>>> call(int id) {
    return repository.getTasksForProject(id);
  }
}
