part of 'update_task_bloc.dart';

abstract class UpdateTaskEvent extends Equatable {
  const UpdateTaskEvent();

  @override
  List<Object> get props => [];
}

class UpdateTaskRequested extends UpdateTaskEvent {
  final Task task;

  const UpdateTaskRequested({required this.task});
}
