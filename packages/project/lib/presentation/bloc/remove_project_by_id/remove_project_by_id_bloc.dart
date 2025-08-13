import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/usecases/remove_project.dart';

part 'remove_project_by_id_event.dart';
part 'remove_project_by_id_state.dart';

class RemoveProjectByIdBloc
    extends Bloc<RemoveProjectByIdEvent, RemoveProjectByIdState> {
  final RemoveProject _removeProjectById;

  RemoveProjectByIdBloc(this._removeProjectById)
    : super(RemoveProjectByIdState()) {
    on<RemoveProjectItemById>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _removeProjectById(event.id);
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
