import 'package:equatable/equatable.dart';
import 'package:task/domain/entities/task.dart';

class TaskWithProjectInfo extends Equatable {
  final Task task;
  final String projectName;

  const TaskWithProjectInfo({required this.task, required this.projectName});

  @override
  List<Object?> get props => [task, projectName];
}
