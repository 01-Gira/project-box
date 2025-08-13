import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/repositories/project_repository.dart';

class RemoveProjects {
  final ProjectRepository repository;

  RemoveProjects(this.repository);

  Future<Either<Failure, String>> call(List<int> ids) {
    return repository.removeProjects(ids);
  }
}
