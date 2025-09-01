import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:task/domain/entities/task_with_project_info.dart';
import 'package:task/domain/repositories/task_repository.dart';

class SearchTasks {
  final TaskRepository repository;
  SearchTasks(this.repository);

  Future<Either<Failure, List<TaskWithProjectInfo>>> call({
    String? query,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return repository.searchTasks(
      query: query,
      dueDate: dueDate,
      isCompleted: isCompleted,
    );
  }
}
