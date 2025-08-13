part of 'create_project_bloc.dart';

abstract class CreateProjectEvent extends Equatable {
  const CreateProjectEvent();

  @override
  List<Object> get props => [];
}

class ProjectSubmitted extends CreateProjectEvent {
  final String name;
  final String? description;
  final File? coverImageFile;
  final String status;
  final DateTime? completionDate;

  const ProjectSubmitted({
    required this.name,
    this.description,
    this.coverImageFile,
    required this.status,
    this.completionDate,
  });
}
