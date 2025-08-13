import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/repositories/project_repository.dart';

class GetProjectById {
  final ProjectRepository repository;
  GetProjectById(this.repository);

  Future<Either<Failure, Project>> call(int id) {
    return repository.getProjectById(id);
  }
}
