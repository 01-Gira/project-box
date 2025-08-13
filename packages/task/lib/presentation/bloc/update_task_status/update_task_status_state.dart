part of 'update_task_status_bloc.dart';

class UpdateTaskStatusState extends Equatable {
  final RequestState state;
  final String? message;

  const UpdateTaskStatusState({
    this.state = RequestState.empty,
    this.message = '',
  });

  UpdateTaskStatusState copyWith({RequestState? state, String? message}) {
    return UpdateTaskStatusState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
