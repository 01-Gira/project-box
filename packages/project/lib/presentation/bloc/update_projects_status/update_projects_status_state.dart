part of 'update_projects_status_bloc.dart';

class UpdateProjectsStatusState extends Equatable {
  final RequestState state;
  final String? message;

  const UpdateProjectsStatusState({
    this.state = RequestState.empty,
    this.message = '',
  });

  UpdateProjectsStatusState copyWith({RequestState? state, String? message}) {
    return UpdateProjectsStatusState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
