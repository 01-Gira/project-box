part of 'get_progress_logs_for_project_bloc.dart';

abstract class GetProgressLogsForProjectEvent extends Equatable {
  const GetProgressLogsForProjectEvent();

  @override
  List<Object> get props => [];
}

class FetchProgressLogItems extends GetProgressLogsForProjectEvent {
  final int id;

  const FetchProgressLogItems({required this.id});
}
