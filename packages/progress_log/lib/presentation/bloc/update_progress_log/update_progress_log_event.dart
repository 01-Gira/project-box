part of 'update_progress_log_bloc.dart';

abstract class UpdateProgressLogEvent extends Equatable {
  const UpdateProgressLogEvent();

  @override
  List<Object> get props => [];
}

class UpdateProgressLogRequested extends UpdateProgressLogEvent {
  final int logId;
  final String logText;
  final String? imagePath;

  const UpdateProgressLogRequested({
    required this.logId,
    required this.logText,
    this.imagePath,
  });
}
