part of 'edit_project_bloc.dart';

abstract class EditProjectEvent extends Equatable {
  const EditProjectEvent();

  @override
  List<Object> get props => [];
}

class ProjectUpdateSubmitted extends EditProjectEvent {
  final int id;
  final String name;
  final String? description;
  final String? coverImageFile;
  final String status;
  final DateTime? completionDate;

  const ProjectUpdateSubmitted({
    required this.id,
    required this.name,
    this.description,
    this.coverImageFile,
    required this.status,
    this.completionDate,
  });
}
