import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final int isCompleted;
  final int orderSequence;

  const Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.orderSequence,
  });

  @override
  List<Object?> get props => [id, title, isCompleted, orderSequence];
}
