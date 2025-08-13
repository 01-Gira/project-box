import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/repositories/project_repository.dart';

class GetProjectItems {
  final ProjectRepository repository;
  GetProjectItems(this.repository);

  Future<Either<Failure, List<Project>>> call({int? limit}) {
    return repository.getProjects(limit: limit);
  }
}
