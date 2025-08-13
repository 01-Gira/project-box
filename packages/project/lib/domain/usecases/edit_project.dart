import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/repositories/project_repository.dart';

class EditProject {
  final ProjectRepository repository;
  EditProject(this.repository);

  Future<Either<Failure, String>> call({
    required int id,
    required Project project,
  }) {
    return repository.editProject(id: id, project: project);
  }
}
