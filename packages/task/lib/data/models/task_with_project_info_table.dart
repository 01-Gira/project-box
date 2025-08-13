import 'package:equatable/equatable.dart';
import 'package:task/domain/entities/task.dart';
import 'package:task/domain/entities/task_with_project_info.dart';

class TaskWithProjectInfoTable extends Equatable {
  final int id;
  final String title;
  final int isCompleted;
  final int orderSequence;
  final int projectId;
  final String projectName;

  const TaskWithProjectInfoTable({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.orderSequence,
    required this.projectId,
    required this.projectName,
  });

  factory TaskWithProjectInfoTable.fromMap(Map<String, dynamic> map) {
    return TaskWithProjectInfoTable(
      id: map['id'],
      title: map['title'],
      isCompleted: map['is_completed'],
      orderSequence: map['order_sequence'],
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
    projectId,
    projectName,
  ];
}
