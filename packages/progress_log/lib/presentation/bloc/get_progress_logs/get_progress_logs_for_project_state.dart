part of 'get_progress_logs_for_project_bloc.dart';

class GetProgressLogsForProjectState extends Equatable {
  final RequestState state;
  final String? message;
  final List<ProgressLog>? logs;
  final int? projectId;

  const GetProgressLogsForProjectState({
    this.state = RequestState.empty,
    this.message = '',
    this.logs = const [],
    this.projectId,
  });

  GetProgressLogsForProjectState copyWith({
    RequestState? state,
    String? message,
    List<ProgressLog>? logs,
    int? projectId,
  }) {
    return GetProgressLogsForProjectState(
      state: state ?? this.state,
      message: message ?? this.message,
      logs: logs ?? this.logs,
      projectId: projectId ?? this.projectId,
    );
  }

  @override
  List<Object?> get props => [state, message, logs, projectId];
}
