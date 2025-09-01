part of 'create_task_bloc.dart';

abstract class CreateTaskEvent extends Equatable {
  const CreateTaskEvent();

  @override
  List<Object> get props => [];
}

class TaskSubmitted extends CreateTaskEvent {
  final int projectId;
  final String title;
  final String? description;
  final int? dueDate;
  final int priority;

  const TaskSubmitted({
    required this.projectId,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = 0,
  });
}
