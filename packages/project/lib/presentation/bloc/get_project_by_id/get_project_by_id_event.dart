part of 'get_project_by_id_bloc.dart';

abstract class GetProjectByIdEvent extends Equatable {
  const GetProjectByIdEvent();

  @override
  List<Object> get props => [];
}

class FetchProjectItemById extends GetProjectByIdEvent {
  final int id;

  const FetchProjectItemById({required this.id});
}
