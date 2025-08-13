import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/usecases/remove_projects.dart';

part 'remove_projects_event.dart';
part 'remove_projects_state.dart';

class RemoveProjectsBloc
    extends Bloc<RemoveProjectsEvent, RemoveProjectsState> {
  final RemoveProjects _removeProjects;

  RemoveProjectsBloc(this._removeProjects) : super(RemoveProjectsState()) {
    on<DeleteProjectsRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _removeProjects(event.ids);
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) =>
            emit(state.copyWith(state: RequestState.loaded, message: data)),
      );
    });
  }
}
