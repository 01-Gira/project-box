import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/domain/usecases/get_project_by_id.dart';

part 'get_project_by_id_event.dart';
part 'get_project_by_id_state.dart';

class GetProjectByIdBloc
    extends Bloc<GetProjectByIdEvent, GetProjectByIdState> {
  final GetProjectById _getProjectByIdBloc;

  GetProjectByIdBloc(this._getProjectByIdBloc) : super(GetProjectByIdState()) {
    on<FetchProjectItemById>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _getProjectByIdBloc(event.id);
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) =>
            emit(state.copyWith(state: RequestState.loaded, project: data)),
      );
    });
  }
}
