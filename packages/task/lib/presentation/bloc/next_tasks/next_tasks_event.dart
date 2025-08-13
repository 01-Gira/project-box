part of 'next_tasks_bloc.dart';

abstract class NextTasksEvent extends Equatable {
  const NextTasksEvent();
  @override
  List<Object> get props => [];
}

class FetchNextTasks extends NextTasksEvent {}
