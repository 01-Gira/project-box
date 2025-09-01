import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/usecases/update_task.dart';
import 'package:task/domain/entities/task.dart';

part 'update_task_event.dart';
part 'update_task_state.dart';

class UpdateTaskBloc extends Bloc<UpdateTaskEvent, UpdateTaskState> {
  final UpdateTask _updateTask;

  UpdateTaskBloc(this._updateTask) : super(UpdateTaskState()) {
    on<UpdateTaskRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _updateTask(event.task);

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
