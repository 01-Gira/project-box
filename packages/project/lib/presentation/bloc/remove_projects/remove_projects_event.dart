part of 'remove_projects_bloc.dart';

abstract class RemoveProjectsEvent extends Equatable {
  const RemoveProjectsEvent();

  @override
  List<Object> get props => [];
}

class DeleteProjectsRequested extends RemoveProjectsEvent {
  final List<int> ids;

  const DeleteProjectsRequested({required this.ids});
}
