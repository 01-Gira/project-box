import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/usecases/remove_task.dart';

part 'remove_task_event.dart';
part 'remove_task_state.dart';

class RemoveTaskBloc extends Bloc<RemoveTaskEvent, RemoveTaskState> {
  final RemoveTask _removeTask;

  RemoveTaskBloc(this._removeTask) : super(RemoveTaskState()) {
    on<RemoveTaskRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _removeTask(event.taskId);

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
