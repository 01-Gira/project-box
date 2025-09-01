import 'dart:convert';

import 'package:project/domain/enitites/project.dart';
import 'package:task/domain/entities/task.dart';
import 'package:progress_log/domain/entities/progress_log.dart';

/// Helper utilities to serialize and deserialize domain models
/// to JSON and CSV formats. These helpers are mainly used when
/// exporting or importing data from the application.
class SerializationHelper {
  // ---- JSON ----
  static String projectsToJson(List<Project> projects) => jsonEncode(
    projects
        .map(
          (p) => {
            'id': p.id,
            'name': p.name,
            'description': p.description,
            'coverImage': p.coverImage,
            'status': p.status,
            'creationDate': p.creationDate?.toIso8601String(),
            'completionDate': p.completionDate?.toIso8601String(),
            'totalTasks': p.totalTasks,
            'completedTasks': p.completedTasks,
          },
        )
        .toList(),
  );

  static String tasksToJson(List<Task> tasks) => jsonEncode(
    tasks
        .map(
          (t) => {
            'id': t.id,
            'title': t.title,
            'isCompleted': t.isCompleted,
            'orderSequence': t.orderSequence,
            'dueDate': t.dueDate,
            'priority': t.priority,
            'description': t.description,
            'parentTaskId': t.parentTaskId,
          },
        )
        .toList(),
  );

  static String logsToJson(List<ProgressLog> logs) => jsonEncode(
    logs
        .map(
          (l) => {
            'id': l.id,
            'imagePath': l.imagePath,
            'logText': l.logText,
            'logDate': l.logDate?.toIso8601String(),
          },
        )
        .toList(),
  );

  static List<Project> projectsFromJson(String src, {int startId = 1}) {
    final List list = jsonDecode(src) as List;
    var currentId = startId;
    return list.map((dynamic item) {
      final map = item as Map<String, dynamic>;
      return Project(
        id: map['id'] ?? currentId++,
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        coverImage: map['coverImage'] as String?,
        status: map['status'] ?? 'Active',
        creationDate: map['creationDate'] != null
            ? DateTime.parse(map['creationDate'])
            : null,
        completionDate: map['completionDate'] != null
            ? DateTime.parse(map['completionDate'])
            : null,
        totalTasks: map['totalTasks'] as int?,
        completedTasks: map['completedTasks'] as int?,
      );
    }).toList();
  }

  static List<Task> tasksFromJson(String src, {int startId = 1}) {
    final List list = jsonDecode(src) as List;
    var currentId = startId;
    return list.map((dynamic item) {
      final map = item as Map<String, dynamic>;
      return Task(
        id: map['id'] ?? currentId++,
        title: map['title'] ?? '',
        isCompleted: map['isCompleted'] ?? 0,
        orderSequence: map['orderSequence'] ?? 0,
        dueDate: map['dueDate'] as int?,
        priority: map['priority'] ?? 0,
        description: map['description'] as String?,
        parentTaskId: map['parentTaskId'] as int?,
      );
    }).toList();
  }

  static List<ProgressLog> logsFromJson(String src, {int startId = 1}) {
    final List list = jsonDecode(src) as List;
    var currentId = startId;
    return list.map((dynamic item) {
      final map = item as Map<String, dynamic>;
      return ProgressLog(
        id: map['id'] ?? currentId++,
        imagePath: map['imagePath'] as String?,
        logText: map['logText'] as String?,
        logDate: map['logDate'] != null ? DateTime.parse(map['logDate']) : null,
      );
    }).toList();
  }

  // ---- CSV ----
  static String projectsToCsv(List<Project> projects) {
    final buffer = StringBuffer();
    buffer.writeln(
      'id,name,description,coverImage,status,creationDate,completionDate,totalTasks,completedTasks',
    );
    for (final p in projects) {
      buffer.writeln(
        '${p.id},${_escape(p.name)},${_escape(p.description)},${_escape(p.coverImage)},${p.status},${p.creationDate?.toIso8601String() ?? ''},${p.completionDate?.toIso8601String() ?? ''},${p.totalTasks ?? ''},${p.completedTasks ?? ''}',
      );
    }
    return buffer.toString();
  }

  static String tasksToCsv(List<Task> tasks) {
    final buffer = StringBuffer();
    buffer.writeln(
      'id,title,isCompleted,orderSequence,dueDate,priority,description,parentTaskId',
    );
    for (final t in tasks) {
      buffer.writeln(
        '${t.id},${_escape(t.title)},${t.isCompleted},${t.orderSequence},${t.dueDate ?? ''},${t.priority},${_escape(t.description)},${t.parentTaskId ?? ''}',
      );
    }
    return buffer.toString();
  }

  static String logsToCsv(List<ProgressLog> logs) {
    final buffer = StringBuffer();
    buffer.writeln('id,imagePath,logText,logDate');
    for (final l in logs) {
      buffer.writeln(
        '${l.id},${_escape(l.imagePath)},${_escape(l.logText)},${l.logDate?.toIso8601String() ?? ''}',
      );
    }
    return buffer.toString();
  }

  static String _escape(String? value) {
    if (value == null) return '';
    if (value.contains(',') || value.contains('"')) {
      return '"' + value.replaceAll('"', '""') + '"';
    }
    return value;
  }
}
