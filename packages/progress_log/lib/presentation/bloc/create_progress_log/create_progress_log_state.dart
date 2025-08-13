part of 'create_progress_log_bloc.dart';

class CreateProgressLogState extends Equatable {
  final RequestState state;
  final String? message;

  const CreateProgressLogState({
    this.state = RequestState.empty,
    this.message = '',
  });

  CreateProgressLogState copyWith({RequestState? state, String? message}) {
    return CreateProgressLogState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
