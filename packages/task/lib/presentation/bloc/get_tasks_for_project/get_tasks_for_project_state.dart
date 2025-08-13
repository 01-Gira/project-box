part of 'get_tasks_for_project_bloc.dart';

class GetTasksForProjectState extends Equatable {
  final RequestState state;
  final String? message;
  final List<Task>? tasks;
  final int? projectId;

  const GetTasksForProjectState({
    this.state = RequestState.empty,
    this.message = '',
    this.tasks = const [],
    this.projectId,
  });

  GetTasksForProjectState copyWith({
    RequestState? state,
    String? message,
    List<Task>? tasks,
    int? projectId,
  }) {
    return GetTasksForProjectState(
      state: state ?? this.state,
      message: message ?? this.message,
      tasks: tasks ?? this.tasks,
      projectId: projectId ?? this.projectId,
    );
  }

  @override
  List<Object?> get props => [state, message, tasks, projectId];
}
