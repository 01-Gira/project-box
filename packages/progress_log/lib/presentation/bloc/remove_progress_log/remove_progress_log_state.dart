part of 'remove_progress_log_bloc.dart';

class RemoveProgressLogState extends Equatable {
  final RequestState state;
  final String? message;

  const RemoveProgressLogState({
    this.state = RequestState.empty,
    this.message = '',
  });

  RemoveProgressLogState copyWith({RequestState? state, String? message}) {
    return RemoveProgressLogState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
