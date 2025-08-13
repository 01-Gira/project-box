part of 'get_project_items_bloc.dart';

class GetProjectItemsState extends Equatable {
  final RequestState state;
  final String? message;
  final List<Project>? projects;
  final List<Project> filteredProjects;

  const GetProjectItemsState({
    this.state = RequestState.empty,
    this.message = '',
    this.projects = const [],
    this.filteredProjects = const [],
  });

  GetProjectItemsState copyWith({
    RequestState? state,
    String? message,
    List<Project>? projects,
    List<Project>? filteredProjects,
  }) {
    return GetProjectItemsState(
      state: state ?? this.state,
      message: message ?? this.message,
      projects: projects ?? this.projects,
      filteredProjects: filteredProjects ?? this.filteredProjects,
    );
  }

  @override
  List<Object?> get props => [state, message, projects, filteredProjects];
}
