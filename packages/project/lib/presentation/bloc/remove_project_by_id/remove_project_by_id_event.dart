part of 'remove_project_by_id_bloc.dart';

abstract class RemoveProjectByIdEvent extends Equatable {
  const RemoveProjectByIdEvent();

  @override
  List<Object> get props => [];
}

class RemoveProjectItemById extends RemoveProjectByIdEvent {
  final int id;

  const RemoveProjectItemById({required this.id});
}
