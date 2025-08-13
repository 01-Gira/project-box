part of 'update_tasks_order_bloc.dart';

class UpdateTasksOrderState extends Equatable {
  final RequestState state;
  final String? message;

  const UpdateTasksOrderState({
    this.state = RequestState.empty,
    this.message = '',
  });

  UpdateTasksOrderState copyWith({RequestState? state, String? message}) {
    return UpdateTasksOrderState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
