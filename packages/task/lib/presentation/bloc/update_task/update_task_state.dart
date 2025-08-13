part of 'update_task_bloc.dart';

class UpdateTaskState extends Equatable {
  final RequestState state;
  final String? message;

  const UpdateTaskState({this.state = RequestState.empty, this.message = ''});

  UpdateTaskState copyWith({RequestState? state, String? message}) {
    return UpdateTaskState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
