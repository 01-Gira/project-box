import 'package:flutter/material.dart';
import 'package:task/domain/entities/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(bool isCompleted) onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusChanged, // Jadikan required
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted == 1,
          onChanged: (bool? value) {
            if (value != null) {
              onStatusChanged(value);
            }
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted == 1
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted == 1 ? Colors.grey : null,
          ),
        ),
      ),
    );
  }
}
