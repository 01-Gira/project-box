import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/repositories/project_repository.dart';

class UpdateProjectsStatus {
  final ProjectRepository repository;

  UpdateProjectsStatus(this.repository);

  Future<Either<Failure, String>> call(List<int> ids, String newStatus) {
    return repository.updateProjectsStatus(ids, newStatus);
  }
}
