part of 'update_projects_status_bloc.dart';

abstract class UpdateProjectsStatusEvent extends Equatable {
  const UpdateProjectsStatusEvent();

  @override
  List<Object> get props => [];
}

class UpdateProjectsStatusRequested extends UpdateProjectsStatusEvent {
  final List<int> ids;
  final String newStatus;

  const UpdateProjectsStatusRequested({
    required this.ids,
    required this.newStatus,
  });
}
