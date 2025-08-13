import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/repositories/project_repository.dart';

class RemoveProject {
  final ProjectRepository repository;
  RemoveProject(this.repository);

  Future<Either<Failure, String>> call(int id) {
    return repository.removeProjectById(id);
  }
}
