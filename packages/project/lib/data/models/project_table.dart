import 'package:equatable/equatable.dart';
import 'package:project/domain/enitites/project.dart';

class ProjectTable extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? coverImage;
  final String status;
  final int? creationDate;
  final int? completionDate;
  final int? totalTasks;
  final int? completedTasks;

  const ProjectTable({
    required this.id,
    required this.name,
    required this.description,
    this.coverImage,
    required this.status,
    this.creationDate,
    this.completionDate,
    this.completedTasks,
    this.totalTasks,
  });

  factory ProjectTable.fromMap(Map<String, dynamic> map) => ProjectTable(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    coverImage: map['cover_image_path'],
    status: map['status'],
    creationDate: map['creation_date'],
    completionDate: map['completion_date'],
    totalTasks: map['total_tasks'],
    completedTasks: map['completed_tasks'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'cover_image_path': coverImage,
    'status': status,
    'creation_date': DateTime.now().millisecondsSinceEpoch,
    'completion_date': completionDate,
  };

  factory ProjectTable.fromEntity(Project project) => ProjectTable(
    id: project.id,
    name: project.name,
    description: project.description,
    coverImage: project.coverImage,
    status: project.status,
    creationDate: project.creationDate?.millisecondsSinceEpoch,
    completionDate: project.completionDate?.millisecondsSinceEpoch,
    totalTasks: project.totalTasks,
    completedTasks: project.completedTasks,
  );

  Project toEntity() => Project(
    id: id,
    name: name,
    description: description,
    coverImage: coverImage,
    status: status,
    creationDate: creationDate != null
        ? DateTime.fromMillisecondsSinceEpoch(creationDate!)
        : null,
    completionDate: completionDate != null
        ? DateTime.fromMillisecondsSinceEpoch(completionDate!)
        : null,
    totalTasks: totalTasks,
    completedTasks: completedTasks,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    coverImage,
    status,
    creationDate,
    completionDate,
  ];
}
