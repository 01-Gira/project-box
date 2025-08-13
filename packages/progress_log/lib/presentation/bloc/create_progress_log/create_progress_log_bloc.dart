import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/domain/usecases/save_progress_log.dart';

part 'create_progress_log_event.dart';
part 'create_progress_log_state.dart';

class CreateProgressLogBloc
    extends Bloc<CreateProgressLogEvent, CreateProgressLogState> {
  final SaveProgressLog _saveProgressLog;

  CreateProgressLogBloc(this._saveProgressLog)
    : super(CreateProgressLogState()) {
    on<ProgressLogSubmitted>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final newLog = ProgressLog(
        id: 0,
        logText: event.logText,
        imagePath: event.imagePath,
      );

      final result = await _saveProgressLog(
        projectId: event.projectId,
        log: newLog,
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
