part of 'remove_project_by_id_bloc.dart';

class RemoveProjectByIdState extends Equatable {
  final RequestState state;
  final String? message;
  final Project? project;

  const RemoveProjectByIdState({
    this.state = RequestState.empty,
    this.message = '',
    this.project,
  });

  RemoveProjectByIdState copyWith({
    RequestState? state,
    String? message,
    Project? project,
  }) {
    return RemoveProjectByIdState(
      state: state ?? this.state,
      message: message ?? this.message,
      project: project ?? this.project,
    );
  }

  @override
  List<Object?> get props => [state, message, project];
}
