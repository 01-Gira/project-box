import 'package:equatable/equatable.dart';
import 'package:task/domain/entities/task.dart';

class TaskTable extends Equatable {
  final int id;
  final String title;
  final int isCompleted;
  final int orderSequence;
  final int? dueDate;
  final int priority;
  final String? description;
  final int? parentTaskId;
  final String? recurrenceRule;
  final int? recurrenceEndDate;

  const TaskTable({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.orderSequence,
    this.dueDate,
    this.priority = 0,
    this.description,
    this.parentTaskId,
    this.recurrenceRule,
    this.recurrenceEndDate,
  });

  factory TaskTable.fromMap(Map<String, dynamic> map) => TaskTable(
    id: map['id'],
    title: map['title'],
    isCompleted: map['is_completed'],
    orderSequence: map['order_sequence'],
    dueDate: map['due_date'],
    priority: map['priority'] ?? 0,
    description: map['description'],
    parentTaskId: map['parent_task_id'],
    recurrenceRule: map['recurrence_rule'],
    recurrenceEndDate: map['recurrence_end_date'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'is_completed': isCompleted,
    'order_sequence': orderSequence,
    'due_date': dueDate,
    'priority': priority,
    'description': description,
    'parent_task_id': parentTaskId,
    'recurrence_rule': recurrenceRule,
    'recurrence_end_date': recurrenceEndDate,
  };

  factory TaskTable.fromEntity(Task task) => TaskTable(
    id: task.id,
    title: task.title,
    isCompleted: task.isCompleted,
    orderSequence: task.orderSequence,
    dueDate: task.dueDate,
    priority: task.priority,
    description: task.description,
    parentTaskId: task.parentTaskId,
    recurrenceRule: task.recurrenceRule,
    recurrenceEndDate: task.recurrenceEndDate,
  );

  Task toEntity() => Task(
    id: id,
    title: title,
    isCompleted: isCompleted,
    orderSequence: orderSequence,
    dueDate: dueDate,
    priority: priority,
    description: description,
    parentTaskId: parentTaskId,
    recurrenceRule: recurrenceRule,
    recurrenceEndDate: recurrenceEndDate,
  );

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
    recurrenceRule,
    recurrenceEndDate,
  ];
}
