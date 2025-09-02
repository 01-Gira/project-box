import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task/presentation/bloc/search_tasks/search_tasks_bloc.dart';
import 'package:task/domain/entities/task_with_project_info.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<TaskWithProjectInfo> _getEventsForDay(
    DateTime day,
    List<TaskWithProjectInfo> tasks,
  ) {
    final date = DateTime(day.year, day.month, day.day);
    return tasks.where((item) {
      final task = item.task;
      if (task.dueDate == null) return false;
      final start = DateTime.fromMillisecondsSinceEpoch(task.dueDate!);
      if (_isSameDay(start, date)) return true;
      if (task.recurrenceRule == null) return false;
      if (date.isBefore(start)) return false;
      if (task.recurrenceEndDate != null) {
        final end = DateTime.fromMillisecondsSinceEpoch(
          task.recurrenceEndDate!,
        );
        if (date.isAfter(end)) return false;
      }
      switch (task.recurrenceRule) {
        case 'daily':
          return true;
        case 'weekly':
          return date.weekday == start.weekday;
        case 'monthly':
          return date.day == start.day;
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchTasksBloc, SearchTasksState>(
      builder: (context, state) {
        final tasks = state.tasks;
        final events = _getEventsForDay(_selectedDay, tasks);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar<TaskWithProjectInfo>(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => _isSameDay(day, _selectedDay),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              eventLoader: (day) => _getEventsForDay(day, tasks),
            ),
            const SizedBox(height: 8),
            ...events.map(
              (item) => ListTile(
                title: Text(item.task.title),
                subtitle: Text(item.projectName),
              ),
            ),
          ],
        );
      },
    );
  }
}
