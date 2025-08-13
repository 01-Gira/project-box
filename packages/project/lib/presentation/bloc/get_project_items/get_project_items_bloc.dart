import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/usecases/get_project_items.dart';
import 'package:project/presentation/bloc/create_project/create_project_bloc.dart';
import 'package:project/presentation/bloc/edit_project/edit_project_bloc.dart';
import 'package:project/presentation/bloc/remove_project_by_id/remove_project_by_id_bloc.dart';
import 'package:project/presentation/bloc/remove_projects/remove_projects_bloc.dart';

import 'package:project/presentation/bloc/update_projects_status/update_projects_status_bloc.dart';
import 'package:task/presentation/bloc/remove_task/remove_task_bloc.dart';
import 'package:task/presentation/bloc/update_task/update_task_bloc.dart';
import 'package:task/presentation/bloc/update_task_status/update_task_status_bloc.dart';

part 'get_project_items_event.dart';
part 'get_project_items_state.dart';

class GetProjectItemsBloc
    extends Bloc<GetProjectItemsEvent, GetProjectItemsState> {
  final GetProjectItems _getProjectItems;

  final List<StreamSubscription> _subscriptions = [];

  GetProjectItemsBloc({
    required GetProjectItems getProjectItems,
    required CreateProjectBloc createProjectBloc,
    required EditProjectBloc editProjectBloc,
    required RemoveProjectByIdBloc removeProjectByIdBloc,
    required RemoveProjectsBloc removeProjectsBloc,
    required UpdateProjectsStatusBloc updateProjectsStatusBloc,
    required UpdateTaskStatusBloc updateTaskStatusBloc,
    required RemoveTaskBloc removeTaskBloc,
    required UpdateTaskBloc updateTaskBloc,
  }) : _getProjectItems = getProjectItems,
       super(GetProjectItemsState()) {
    void listenToBloc(Stream<dynamic> stream) {
      _subscriptions.add(
        stream.listen((state) {
          if (state.state == RequestState.loaded) {
            add(const FetchProjectItems());
          }
        }),
      );
    }

    listenToBloc(createProjectBloc.stream);
    listenToBloc(editProjectBloc.stream);
    listenToBloc(removeProjectByIdBloc.stream);
    listenToBloc(removeProjectsBloc.stream);
    listenToBloc(updateProjectsStatusBloc.stream);
    listenToBloc(updateTaskStatusBloc.stream);
    listenToBloc(removeTaskBloc.stream);
    listenToBloc(updateTaskBloc.stream);

    on<FetchProjectItems>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _getProjectItems(limit: event.limit);
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) =>
            emit(state.copyWith(state: RequestState.loaded, projects: data)),
      );
    });
  }
}
