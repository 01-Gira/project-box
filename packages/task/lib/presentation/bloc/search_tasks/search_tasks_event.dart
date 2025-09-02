part of 'search_tasks_bloc.dart';

abstract class SearchTasksEvent extends Equatable {
  const SearchTasksEvent();

  @override
  List<Object?> get props => [];
}

class SearchTasksRequested extends SearchTasksEvent {
  final String query;
  final DateTime? dueDate;
  final bool? isCompleted;

  const SearchTasksRequested({this.query = '', this.dueDate, this.isCompleted});

  @override
  List<Object?> get props => [query, dueDate, isCompleted];
}
