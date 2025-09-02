part of 'search_tasks_bloc.dart';

class SearchTasksState extends Equatable {
  final RequestState state;
  final List<TaskWithProjectInfo> tasks;
  final String? message;

  const SearchTasksState({
    this.state = RequestState.empty,
    this.tasks = const [],
    this.message,
  });

  SearchTasksState copyWith({
    RequestState? state,
    List<TaskWithProjectInfo>? tasks,
    String? message,
  }) {
    return SearchTasksState(
      state: state ?? this.state,
      tasks: tasks ?? this.tasks,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tasks, message];
}
