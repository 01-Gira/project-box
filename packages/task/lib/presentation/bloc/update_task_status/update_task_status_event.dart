part of 'update_task_status_bloc.dart';

abstract class UpdateTaskStatusEvent extends Equatable {
  const UpdateTaskStatusEvent();

  @override
  List<Object> get props => [];
}

class UpdateTaskStatusRequested extends UpdateTaskStatusEvent {
  final int id;
  final bool isCompleted;

  const UpdateTaskStatusRequested({
    required this.id,
    required this.isCompleted,
  });
}
