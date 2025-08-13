part of 'remove_task_bloc.dart';

abstract class RemoveTaskEvent extends Equatable {
  const RemoveTaskEvent();

  @override
  List<Object> get props => [];
}

class RemoveTaskRequested extends RemoveTaskEvent {
  final int taskId;

  const RemoveTaskRequested({required this.taskId});
}
