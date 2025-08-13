part of 'create_task_bloc.dart';

abstract class CreateTaskEvent extends Equatable {
  const CreateTaskEvent();

  @override
  List<Object> get props => [];
}

class TaskSubmitted extends CreateTaskEvent {
  final int projectId;
  final String title;

  const TaskSubmitted({required this.projectId, required this.title});
}
