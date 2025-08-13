import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/usecases/update_task_status.dart';

part 'update_task_status_event.dart';
part 'update_task_status_state.dart';

class UpdateTaskStatusBloc
    extends Bloc<UpdateTaskStatusEvent, UpdateTaskStatusState> {
  final UpdateTaskStatus _updateTaskStatus;

  UpdateTaskStatusBloc(this._updateTaskStatus)
    : super(UpdateTaskStatusState()) {
    on<UpdateTaskStatusRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _updateTaskStatus(
        id: event.id,
        isCompleted: event.isCompleted,
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
