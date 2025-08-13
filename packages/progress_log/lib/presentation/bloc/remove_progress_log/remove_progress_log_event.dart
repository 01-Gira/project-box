part of 'remove_progress_log_bloc.dart';

abstract class RemoveProgressLogEvent extends Equatable {
  const RemoveProgressLogEvent();

  @override
  List<Object> get props => [];
}

class DeleteProgressLogRequested extends RemoveProgressLogEvent {
  final int logId;

  const DeleteProgressLogRequested({required this.logId});
}
