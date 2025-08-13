part of 'remove_projects_bloc.dart';

class RemoveProjectsState extends Equatable {
  final RequestState state;
  final String? message;

  const RemoveProjectsState({
    this.state = RequestState.empty,
    this.message = '',
  });

  RemoveProjectsState copyWith({RequestState? state, String? message}) {
    return RemoveProjectsState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
