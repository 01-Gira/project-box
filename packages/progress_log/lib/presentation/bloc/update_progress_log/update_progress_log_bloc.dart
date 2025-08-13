import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/domain/usecases/update_progress_log.dart';

part 'update_progress_log_event.dart';
part 'update_progress_log_state.dart';

class UpdateProgressLogBloc
    extends Bloc<UpdateProgressLogEvent, UpdateProgressLogState> {
  final UpdateProgressLog _updateProgressLog;

  UpdateProgressLogBloc(this._updateProgressLog)
    : super(UpdateProgressLogState()) {
    on<UpdateProgressLogRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final updateLog = ProgressLog(
        id: 0,
        logText: event.logText,
        imagePath: event.imagePath,
      );

      final result = await _updateProgressLog(
        logId: event.logId,
        log: updateLog,
      );

      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (message) =>
            emit(state.copyWith(state: RequestState.loaded, message: message)),
      );
    });
  }
}
