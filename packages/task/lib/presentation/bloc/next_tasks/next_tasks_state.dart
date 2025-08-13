part of 'next_tasks_bloc.dart';

class NextTasksState extends Equatable {
  final RequestState state;
  final String? message;
  final List<TaskWithProjectInfo>? tasks;

  const NextTasksState({
    this.state = RequestState.empty,
    this.message = '',
    this.tasks = const [],
  });

  NextTasksState copyWith({
    RequestState? state,
    String? message,
    List<TaskWithProjectInfo>? tasks,
  }) {
    return NextTasksState(
      state: state ?? this.state,
      message: message ?? this.message,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [state, message, tasks];
}
