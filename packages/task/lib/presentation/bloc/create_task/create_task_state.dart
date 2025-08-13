part of 'create_task_bloc.dart';

class CreateTaskState extends Equatable {
  final RequestState state;
  final String? message;

  const CreateTaskState({this.state = RequestState.empty, this.message = ''});

  CreateTaskState copyWith({RequestState? state, String? message}) {
    return CreateTaskState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
