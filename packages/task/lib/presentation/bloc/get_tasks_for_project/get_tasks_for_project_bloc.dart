import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/entities/task.dart';
import 'package:task/domain/usecases/get_tasks_for_project.dart';
import 'package:task/presentation/bloc/create_task/create_task_bloc.dart';
import 'package:task/presentation/bloc/remove_task/remove_task_bloc.dart';
import 'package:task/presentation/bloc/update_task/update_task_bloc.dart';
import 'package:task/presentation/bloc/update_task_status/update_task_status_bloc.dart';
import 'package:task/presentation/bloc/update_tasks_order/update_tasks_order_bloc.dart';

part 'get_tasks_for_project_event.dart';
part 'get_tasks_for_project_state.dart';

class GetTasksForProjectBloc
    extends Bloc<GetTasksForProjectEvent, GetTasksForProjectState> {
  final GetTasksForProject _getTasksForProject;

  final List<StreamSubscription> _subscriptions = [];

  GetTasksForProjectBloc({
    required GetTasksForProject getTasksForProject,
    required CreateTaskBloc createaskStatusBloc,
    required UpdateTaskStatusBloc updateTaskStatusBloc,
    required RemoveTaskBloc removeTaskBloc,
    required UpdateTaskBloc updateTaskBloc,
    required UpdateTasksOrderBloc updateTasksOrderBloc,
  }) : _getTasksForProject = getTasksForProject,
       super(GetTasksForProjectState()) {
    void refreshProgressLogs() {
      if (state.projectId != null) {
        add(FetchTasksItems(id: state.projectId!));
      }
    }

    _subscriptions.add(
      createaskStatusBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) refreshProgressLogs();
      }),
    );
    _subscriptions.add(
      updateTaskStatusBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) refreshProgressLogs();
      }),
    );
    _subscriptions.add(
      removeTaskBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) refreshProgressLogs();
      }),
    );
    _subscriptions.add(
      updateTaskBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) refreshProgressLogs();
      }),
    );
    _subscriptions.add(
      updateTasksOrderBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) refreshProgressLogs();
      }),
    );
    on<FetchTasksItems>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading, projectId: event.id));

      final result = await _getTasksForProject(event.id);
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) => emit(state.copyWith(state: RequestState.loaded, tasks: data)),
      );
    });
  }
}
