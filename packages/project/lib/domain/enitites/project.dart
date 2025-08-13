import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? coverImage;
  final String status;
  final DateTime? creationDate;
  final DateTime? completionDate;
  final int? totalTasks;
  final int? completedTasks;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    this.coverImage,
    required this.status,
    this.creationDate,
    this.completionDate,
    this.totalTasks,
    this.completedTasks,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    coverImage,
    status,
    creationDate,
    completionDate,
    totalTasks,
    completedTasks,
  ];
}
