import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/repositories/project_repository.dart';

class SaveProject {
  final ProjectRepository repository;
  SaveProject(this.repository);

  Future<Either<Failure, String>> call(Project project) {
    return repository.saveProject(project);
  }
}
