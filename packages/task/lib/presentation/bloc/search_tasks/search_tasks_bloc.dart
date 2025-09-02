import 'package:core/common/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/entities/task_with_project_info.dart';
import 'package:task/domain/usecases/search_tasks.dart';

part 'search_tasks_event.dart';
part 'search_tasks_state.dart';

class SearchTasksBloc extends Bloc<SearchTasksEvent, SearchTasksState> {
  final SearchTasks _searchTasks;

  SearchTasksBloc({required SearchTasks searchTasks})
    : _searchTasks = searchTasks,
      super(const SearchTasksState()) {
    on<SearchTasksRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));
      final result = await _searchTasks(
        query: event.query,
        dueDate: event.dueDate,
        isCompleted: event.isCompleted,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) => emit(state.copyWith(state: RequestState.loaded, tasks: data)),
      );
    });
  }
}
