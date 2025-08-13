import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/entities/task_with_project_info.dart';
import 'package:task/domain/repositories/task_repository.dart';

class GetNextTasks {
  final TaskRepository repository;

  GetNextTasks(this.repository);

  Future<Either<Failure, List<TaskWithProjectInfo>>> call() {
    return repository.getNextTasks();
  }
}
