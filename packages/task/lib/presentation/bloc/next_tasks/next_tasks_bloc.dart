import 'dart:async';

import 'package:core/common/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/presentation/bloc/edit_project/edit_project_bloc.dart';
import 'package:project/presentation/bloc/remove_project_by_id/remove_project_by_id_bloc.dart';
import 'package:task/domain/entities/task_with_project_info.dart';
import 'package:task/domain/usecases/get_next_tasks.dart';
import 'package:task/presentation/bloc/create_task/create_task_bloc.dart';
import 'package:task/presentation/bloc/remove_task/remove_task_bloc.dart';
import 'package:task/presentation/bloc/update_task/update_task_bloc.dart';
import 'package:task/presentation/bloc/update_task_status/update_task_status_bloc.dart';
import 'package:task/presentation/bloc/update_tasks_order/update_tasks_order_bloc.dart';

part 'next_tasks_event.dart';
part 'next_tasks_state.dart';

class NextTasksBloc extends Bloc<NextTasksEvent, NextTasksState> {
  final GetNextTasks _getNextTasks;

  final List<StreamSubscription> _subscriptions = [];

  NextTasksBloc({
    required GetNextTasks getNextTasks,
    required EditProjectBloc editProjectBloc,
    required RemoveProjectByIdBloc removeProjectByIdBloc,
    required CreateTaskBloc createTaskBloc,
    required UpdateTaskStatusBloc updateTaskStatusBloc,
    required RemoveTaskBloc removeTaskBloc,
    required UpdateTaskBloc updateTaskBloc,
    required UpdateTasksOrderBloc updateTasksOrderBloc,
  }) : _getNextTasks = getNextTasks,
       super(NextTasksState()) {
    void listenToBloc(Stream<dynamic> stream) {
      _subscriptions.add(
        stream.listen((state) {
          if (state.state == RequestState.loaded) {
            add(FetchNextTasks());
          }
        }),
      );
    }

    listenToBloc(editProjectBloc.stream);
    listenToBloc(removeProjectByIdBloc.stream);
    listenToBloc(createTaskBloc.stream);
    listenToBloc(updateTaskStatusBloc.stream);
    listenToBloc(removeTaskBloc.stream);
    listenToBloc(updateTaskBloc.stream);
    listenToBloc(updateTasksOrderBloc.stream);
    listenToBloc(removeTaskBloc.stream);
    listenToBloc(removeTaskBloc.stream);

    on<FetchNextTasks>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));
      final result = await _getNextTasks.call();

      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) => emit(state.copyWith(state: RequestState.loaded, tasks: data)),
      );
    });
  }

  @override
  Future<void> close() {
    // Batalkan semua subscription saat BLoC ditutup
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    return super.close();
  }
}
