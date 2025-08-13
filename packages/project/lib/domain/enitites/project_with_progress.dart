import 'package:equatable/equatable.dart';

class ProjectWithProgress extends Equatable {
  final String name;
  final int totalTasks;
  final int completedTasks;

  const ProjectWithProgress({
    required this.name,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  List<Object?> get props => [name, totalTasks, completedTasks];
}
