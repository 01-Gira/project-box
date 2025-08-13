part of 'update_tasks_order_bloc.dart';

abstract class UpdateTasksOrderEvent extends Equatable {
  const UpdateTasksOrderEvent();

  @override
  List<Object> get props => [];
}

class UpdateTaskOrderRequested extends UpdateTasksOrderEvent {
  final List<entity.Task> tasks;

  const UpdateTaskOrderRequested({required this.tasks});
}
