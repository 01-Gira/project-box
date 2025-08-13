import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/entities/task.dart';
import 'package:task/domain/usecases/get_tasks_for_project.dart';
import 'package:task/domain/usecases/save_task.dart';

part 'create_task_event.dart';
part 'create_task_state.dart';

class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {
  final SaveTask _saveTask;
  final GetTasksForProject _getTasksForProject;

  CreateTaskBloc(this._saveTask, this._getTasksForProject)
    : super(CreateTaskState()) {
    on<TaskSubmitted>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final resultTasks = await _getTasksForProject(event.projectId);
      int newOrder = 1;

      resultTasks.fold(
        (failure) {
          // Bisa default ke 1 kalau gagal ambil
          newOrder = 1;
        },
        (tasks) {
          if (tasks.isNotEmpty) {
            final maxOrder = tasks
                .map((t) => t.orderSequence)
                .reduce((a, b) => a > b ? a : b);
            newOrder = maxOrder + 1;
          }
        },
      );

      final newTask = Task(
        id: 0,
        title: event.title,
        isCompleted: 0,
        orderSequence: newOrder,
      );

      final result = await _saveTask(projectId: event.projectId, task: newTask);

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
