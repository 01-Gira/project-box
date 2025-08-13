import 'package:equatable/equatable.dart';
import 'package:task/domain/entities/task.dart';

class TaskTable extends Equatable {
  final int id;
  final String title;
  final int isCompleted;
  final int orderSequence;

  const TaskTable({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.orderSequence,
  });

  factory TaskTable.fromMap(Map<String, dynamic> map) => TaskTable(
    id: map['id'],
    title: map['title'],
    isCompleted: map['is_completed'],
    orderSequence: map['order_sequence'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'is_completed': isCompleted,
    'order_sequence': orderSequence,
  };

  factory TaskTable.fromEntity(Task task) => TaskTable(
    id: task.id,
    title: task.title,
    isCompleted: task.isCompleted,
    orderSequence: task.orderSequence,
  );

  Task toEntity() => Task(
    id: id,
    title: title,
    isCompleted: isCompleted,
    orderSequence: orderSequence,
  );

  @override
  List<Object?> get props => [id, title, isCompleted, orderSequence];
}
