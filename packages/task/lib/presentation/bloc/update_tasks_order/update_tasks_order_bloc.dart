import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/entities/task.dart' as entity;
import 'package:task/domain/usecases/update_tasks_order.dart';

part 'update_tasks_order_event.dart';
part 'update_tasks_order_state.dart';

class UpdateTasksOrderBloc
    extends Bloc<UpdateTasksOrderEvent, UpdateTasksOrderState> {
  final UpdateTasksOrder _updateTasksOrder;

  UpdateTasksOrderBloc(this._updateTasksOrder)
    : super(UpdateTasksOrderState()) {
    on<UpdateTaskOrderRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _updateTasksOrder(event.tasks);

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
