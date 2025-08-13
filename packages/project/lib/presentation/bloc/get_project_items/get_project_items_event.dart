part of 'get_project_items_bloc.dart';

abstract class GetProjectItemsEvent extends Equatable {
  const GetProjectItemsEvent();

  @override
  List<Object> get props => [];
}

class FetchProjectItems extends GetProjectItemsEvent {
  final int? limit;
  const FetchProjectItems({this.limit});
}
