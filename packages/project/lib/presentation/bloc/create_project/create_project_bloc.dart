import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/usecases/save_project.dart';

part 'create_project_event.dart';
part 'create_project_state.dart';

class CreateProjectBloc extends Bloc<CreateProjectEvent, CreateProjectState> {
  final SaveProject _saveProject;

  CreateProjectBloc(this._saveProject) : super(CreateProjectState()) {
    on<ProjectSubmitted>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final newProject = Project(
        id: 0,
        name: event.name,
        description: event.description ?? '',
        coverImage: event.coverImageFile?.path,
        status: event.status,
        creationDate: null,
        completionDate: event.completionDate,
      );

      final result = await _saveProject(newProject);

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
