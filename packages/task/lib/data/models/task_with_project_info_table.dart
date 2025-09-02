import 'package:equatable/equatable.dart';
import 'package:task/domain/entities/task.dart';
import 'package:task/domain/entities/task_with_project_info.dart';

class TaskWithProjectInfoTable extends Equatable {
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
  final int projectId;
  final String projectName;

  const TaskWithProjectInfoTable({
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
    required this.projectId,
    required this.projectName,
  });

  factory TaskWithProjectInfoTable.fromMap(Map<String, dynamic> map) {
    return TaskWithProjectInfoTable(
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
      projectId: map['project_id'],
      projectName: map['project_name'],
    );
  }

  // Mengubah model data menjadi entitas domain
  TaskWithProjectInfo toEntity() {
    return TaskWithProjectInfo(
      task: Task(
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
      ),
      projectName: projectName,
    );
  }

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
    projectId,
    projectName,
  ];
}
