part of 'get_tasks_for_project_bloc.dart';

abstract class GetTasksForProjectEvent extends Equatable {
  const GetTasksForProjectEvent();

  @override
  List<Object> get props => [];
}

class FetchTasksItems extends GetTasksForProjectEvent {
  final int id;

  const FetchTasksItems({required this.id});
}
