import 'package:equatable/equatable.dart';
import 'package:project/domain/enitites/project_with_progress.dart';

class ProjectWithProgressTable extends Equatable {
  final String name;
  final int totalTasks;
  final int completedTasks;

  const ProjectWithProgressTable({
    required this.name,
    required this.totalTasks,
    required this.completedTasks,
  });

  factory ProjectWithProgressTable.fromMap(Map<String, dynamic> map) =>
      ProjectWithProgressTable(
        name: map['name'],
        totalTasks: map['total_tasks'],
        completedTasks: map['completed_tasks'],
      );

  ProjectWithProgress toEntity() => ProjectWithProgress(
    name: name,
    totalTasks: totalTasks,
    completedTasks: completedTasks,
  );

  @override
  List<Object?> get props => [name, totalTasks, completedTasks];
}
