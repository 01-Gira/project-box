import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final int isCompleted;
  final int orderSequence;
  final int? dueDate;
  final int priority;
  final String? description;
  final int? parentTaskId;

  const Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.orderSequence,
    this.dueDate,
    this.priority = 0,
    this.description,
    this.parentTaskId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    isCompleted,
    orderSequence,
    dueDate,
    priority,
    description,
    parentTaskId,
  ];
}
