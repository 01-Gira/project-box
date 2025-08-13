import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/usecases/update_projects_status.dart';

part 'update_projects_status_event.dart';
part 'update_projects_status_state.dart';

class UpdateProjectsStatusBloc
    extends Bloc<UpdateProjectsStatusEvent, UpdateProjectsStatusState> {
  final UpdateProjectsStatus _updateProjectsStatus;

  UpdateProjectsStatusBloc(this._updateProjectsStatus)
    : super(UpdateProjectsStatusState()) {
    on<UpdateProjectsStatusRequested>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await _updateProjectsStatus(event.ids, event.newStatus);
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
