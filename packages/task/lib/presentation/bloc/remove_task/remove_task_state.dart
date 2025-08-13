part of 'remove_task_bloc.dart';

class RemoveTaskState extends Equatable {
  final RequestState state;
  final String? message;

  const RemoveTaskState({this.state = RequestState.empty, this.message = ''});

  RemoveTaskState copyWith({RequestState? state, String? message}) {
    return RemoveTaskState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
