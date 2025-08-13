part of 'create_project_bloc.dart';

class CreateProjectState extends Equatable {
  final RequestState state;
  final String? message;

  const CreateProjectState({
    this.state = RequestState.empty,
    this.message = '',
  });

  CreateProjectState copyWith({RequestState? state, String? message}) {
    return CreateProjectState(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, message];
}
