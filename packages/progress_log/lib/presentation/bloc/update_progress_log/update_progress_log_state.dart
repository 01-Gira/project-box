part of 'update_progress_log_bloc.dart';

class UpdateProgressLogState extends Equatable {
  final RequestState state;
  final String? message;

  const UpdateProgressLogState({
    this.state = RequestState.empty,
    this.message = '',
  });

  UpdateProgressLogState copyWith({RequestState? state, String? message}) {
    return UpdateProgressLogState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
