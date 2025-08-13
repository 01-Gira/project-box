import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/domain/usecases/get_progress_log.dart';
import 'package:progress_log/presentation/bloc/create_progress_log/create_progress_log_bloc.dart';
import 'package:progress_log/presentation/bloc/remove_progress_log/remove_progress_log_bloc.dart';
import 'package:progress_log/presentation/bloc/update_progress_log/update_progress_log_bloc.dart';

part 'get_progress_logs_for_project_event.dart';
part 'get_progress_logs_for_project_state.dart';

class GetProgressLogsForProjectBloc
    extends
        Bloc<GetProgressLogsForProjectEvent, GetProgressLogsForProjectState> {
  final GetProgressLog _getTasksForProject;
  final List<StreamSubscription> _subscriptions = [];

  GetProgressLogsForProjectBloc({
    required GetProgressLog getProgressLog,
    required CreateProgressLogBloc createProgressLogBloc,
    required RemoveProgressLogBloc removeProgressLogBloc,
    required UpdateProgressLogBloc updateProgressLogBloc,
  }) : _getTasksForProject = getProgressLog,
       super(GetProgressLogsForProjectState()) {
    // Fungsi helper untuk mendengarkan BLoC aksi
    void listenToBloc(Stream<dynamic> stream) {
      _subscriptions.add(
        stream.listen((state) {
          // Jika aksi berhasil, picu refresh
          if (state.state == RequestState.loaded) {
            if (this.state.projectId != null) {
              add(FetchProgressLogItems(id: this.state.projectId!));
            }
          }
        }),
      );
    }

    // Dengarkan semua BLoC aksi yang relevan
    listenToBloc(createProgressLogBloc.stream);
    listenToBloc(removeProgressLogBloc.stream);
    listenToBloc(updateProgressLogBloc.stream);
    on<FetchProgressLogItems>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading, projectId: event.id));

      final result = await _getTasksForProject(event.id);
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) => emit(state.copyWith(state: RequestState.loaded, logs: data)),
      );
    });
  }
}
