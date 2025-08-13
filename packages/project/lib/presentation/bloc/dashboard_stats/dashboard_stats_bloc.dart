import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/enitites/dashboard_stats.dart';
import 'package:project/domain/usecases/get_dashboard_stats.dart';
import 'package:project/presentation/bloc/edit_project/edit_project_bloc.dart';
import 'package:project/presentation/bloc/remove_project_by_id/remove_project_by_id_bloc.dart';
import 'package:task/presentation/bloc/remove_task/remove_task_bloc.dart';
import 'package:task/presentation/bloc/update_task_status/update_task_status_bloc.dart';

part 'dashboard_stats_event.dart';
part 'dashboard_stats_state.dart';

class DashboardStatsBloc
    extends Bloc<DashboardStatsEvent, DashboardStatsState> {
  final GetDashboardStats _getDashboardStats;

  final List<StreamSubscription> _subscriptions = [];

  DashboardStatsBloc({
    required GetDashboardStats getDashboardStats,
    required EditProjectBloc editProjectBloc,
    required RemoveProjectByIdBloc removeProjectByIdBloc,
    required UpdateTaskStatusBloc updateTaskStatusBloc,
    required RemoveTaskBloc removeTaskBloc,
  }) : _getDashboardStats = getDashboardStats,
       super(DashboardStatsState()) {
    _subscriptions.add(
      editProjectBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) {
          add(FetchDashboardStats());
        }
      }),
    );

    _subscriptions.add(
      removeProjectByIdBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) {
          add(FetchDashboardStats());
        }
      }),
    );

    _subscriptions.add(
      updateTaskStatusBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) {
          add(FetchDashboardStats());
        }
      }),
    );

    _subscriptions.add(
      removeTaskBloc.stream.listen((state) {
        if (state.state == RequestState.loaded) {
          add(FetchDashboardStats());
        }
      }),
    );

    on<FetchDashboardStats>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _getDashboardStats();
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) => emit(state.copyWith(state: RequestState.loaded, stats: data)),
      );
    });
  }
}
