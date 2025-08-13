import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/usecases/edit_project.dart';

part 'edit_project_event.dart';
part 'edit_project_state.dart';

class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  final EditProject _editProject;

  EditProjectBloc(this._editProject) : super(EditProjectState()) {
    on<ProjectUpdateSubmitted>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final newProject = Project(
        id: 0,
        name: event.name,
        description: event.description ?? '',
        coverImage: event.coverImageFile,
        status: event.status,
        creationDate: null,
        completionDate: event.completionDate,
      );

      final result = await _editProject(id: event.id, project: newProject);

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
