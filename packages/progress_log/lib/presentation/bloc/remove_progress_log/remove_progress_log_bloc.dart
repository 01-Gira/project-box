import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_log/domain/usecases/remove_progress_log.dart';

part 'remove_progress_log_event.dart';
part 'remove_progress_log_state.dart';

class RemoveProgressLogBloc
    extends Bloc<RemoveProgressLogEvent, RemoveProgressLogState> {
  final RemoveProgressLog _removeProgressLog;

  RemoveProgressLogBloc(this._removeProgressLog)
    : super(RemoveProgressLogState()) {
    on<DeleteProgressLogRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _removeProgressLog(event.logId);

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
