part of 'create_progress_log_bloc.dart';

abstract class CreateProgressLogEvent extends Equatable {
  const CreateProgressLogEvent();

  @override
  List<Object> get props => [];
}

class ProgressLogSubmitted extends CreateProgressLogEvent {
  final int projectId;
  final String logText;
  final String? imagePath;

  const ProgressLogSubmitted({
    required this.projectId,
    required this.logText,
    this.imagePath,
  });
}
