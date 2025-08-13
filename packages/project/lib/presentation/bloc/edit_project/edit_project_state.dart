part of 'edit_project_bloc.dart';

class EditProjectState extends Equatable {
  final RequestState state;
  final String? message;

  const EditProjectState({this.state = RequestState.empty, this.message = ''});

  EditProjectState copyWith({RequestState? state, String? message}) {
    return EditProjectState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
