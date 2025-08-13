part of 'get_project_by_id_bloc.dart';

class GetProjectByIdState extends Equatable {
  final RequestState state;
  final String? message;
  final Project? project;

  const GetProjectByIdState({
    this.state = RequestState.empty,
    this.message = '',
    this.project,
  });

  GetProjectByIdState copyWith({
    RequestState? state,
    String? message,
    Project? project,
  }) {
    return GetProjectByIdState(
      state: state ?? this.state,
      message: message ?? this.message,
      project: project ?? this.project,
    );
  }

  @override
  List<Object?> get props => [state, message, project];
}
