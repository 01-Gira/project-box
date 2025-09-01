import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/entities/task.dart';
import 'package:task/presentation/bloc/create_task/create_task_bloc.dart';
import 'package:task/presentation/bloc/get_tasks_for_project/get_tasks_for_project_bloc.dart';
import 'package:task/presentation/bloc/remove_task/remove_task_bloc.dart';
import 'package:task/presentation/bloc/update_task/update_task_bloc.dart';
import 'package:task/presentation/bloc/update_task_status/update_task_status_bloc.dart';
import 'package:task/presentation/bloc/update_tasks_order/update_tasks_order_bloc.dart';
import 'package:task/presentation/widgets/task_card.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  final int projectId;
  const TaskPage({super.key, required this.projectId});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> _localTasks = [];
  String _sortOption = 'order';

  void _sortTasks() {
    if (_sortOption == 'dueDate') {
      _localTasks.sort((a, b) => (a.dueDate ?? 0).compareTo(b.dueDate ?? 0));
    } else if (_sortOption == 'priority') {
      _localTasks.sort((a, b) => b.priority.compareTo(a.priority));
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<GetTasksForProjectBloc>().add(
      FetchTasksItems(id: widget.projectId),
    );
  }

  Widget _buildDismissibleTask(
    Task task,
    int index,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    bool showDragHandle,
  ) {
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        color: colorScheme.primary,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(Icons.edit_outlined, color: colorScheme.onPrimary),
      ),
      secondaryBackground: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(Icons.delete_outline, color: colorScheme.onError),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await _showEditTaskDialog(task, l10n);
          return false;
        } else {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(l10n.confirmDelete),
                content: Text(l10n.confirmationDelete),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      l10n.delete,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          context.read<RemoveTaskBloc>().add(
            RemoveTaskRequested(taskId: task.id),
          );
          setState(() {
            _localTasks.removeAt(index);
          });
        }
      },
      child: Row(
        children: [
          Expanded(
            child: TaskCard(
              task: task,
              onStatusChanged: (isCompleted) {
                context.read<UpdateTaskStatusBloc>().add(
                  UpdateTaskStatusRequested(
                    id: task.id,
                    isCompleted: isCompleted,
                  ),
                );
              },
            ),
          ),
          if (showDragHandle)
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.drag_handle),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showEditTaskDialog(Task task, AppLocalizations l10n) async {
    final TextEditingController titleController = TextEditingController(
      text: task.title,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: task.description ?? '',
    );
    DateTime? dueDate = task.dueDate != null
        ? DateTime.fromMillisecondsSinceEpoch(task.dueDate!)
        : null;
    int priority = task.priority;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.edit, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: l10n.taskTitleLabel),
                  autofocus: true,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: List.generate(
                    5,
                    (index) =>
                        DropdownMenuItem(value: index, child: Text('$index')),
                  ),
                  onChanged: (value) => setState(() => priority = value ?? 0),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dueDate != null
                            ? DateFormat.yMd().format(dueDate!)
                            : 'Due Date',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: dueDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => dueDate = picked);
                        }
                      },
                      child: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop({
                    'title': titleController.text.trim(),
                    'description': descriptionController.text.trim(),
                    'priority': priority,
                    'dueDate': dueDate?.millisecondsSinceEpoch,
                  }),
                  child: Text(l10n.save),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );

    if (result != null) {
      final updatedTask = Task(
        id: task.id,
        title: result['title'],
        isCompleted: task.isCompleted,
        orderSequence: task.orderSequence,
        description: (result['description'] as String).isEmpty
            ? null
            : result['description'],
        priority: result['priority'] as int,
        dueDate: result['dueDate'] as int?,
      );

      if (mounted) {
        context.read<UpdateTaskBloc>().add(
          UpdateTaskRequested(task: updatedTask),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<GetTasksForProjectBloc, GetTasksForProjectState>(
          listener: (context, state) {
            if (state.state == RequestState.loaded) {
              setState(() {
                _localTasks = state.tasks ?? [];
                _sortTasks();
              });
            }
          },
        ),
        BlocListener<CreateTaskBloc, CreateTaskState>(
          listener: (context, state) {
            if (state.state == RequestState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.somethingWentWrong),
                  backgroundColor: colorScheme.error,
                ),
              );
            }
          },
        ),
        BlocListener<UpdateTasksOrderBloc, UpdateTasksOrderState>(
          listener: (context, state) {
            if (state.state == RequestState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: colorScheme.error,
                ),
              );
            }
          },
        ),
        BlocListener<UpdateTaskBloc, UpdateTaskState>(
          listener: (context, state) {
            if (state.state == RequestState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: colorScheme.error,
                ),
              );
            }
          },
        ),
        BlocListener<UpdateTaskStatusBloc, UpdateTaskStatusState>(
          listener: (context, state) {
            if (state.state == RequestState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: colorScheme.error,
                ),
              );
            }
          },
        ),
        BlocListener<RemoveTaskBloc, RemoveTaskState>(
          listener: (context, state) {
            if (state.state == RequestState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: colorScheme.error,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetTasksForProjectBloc, GetTasksForProjectState>(
        builder: (context, state) {
          switch (state.state) {
            case RequestState.loading:
              return const Center(child: CircularProgressIndicator());
            case RequestState.error:
              return Center(child: Text(l10n.somethingWentWrong));
            case RequestState.loaded:
              if (_localTasks.isEmpty) {
                return Center(child: Text(l10n.emptyTask));
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: _sortOption,
                      items: const [
                        DropdownMenuItem(value: 'order', child: Text('Manual')),
                        DropdownMenuItem(
                          value: 'dueDate',
                          child: Text('Due Date'),
                        ),
                        DropdownMenuItem(
                          value: 'priority',
                          child: Text('Priority'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortOption = value;
                            _sortTasks();
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: _sortOption == 'order'
                        ? ReorderableListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _localTasks.length,
                            itemBuilder: (context, index) {
                              final task = _localTasks[index];

                              return _buildDismissibleTask(
                                task,
                                index,
                                colorScheme,
                                l10n,
                                true,
                              );
                            },
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final Task item = _localTasks.removeAt(
                                  oldIndex,
                                );
                                _localTasks.insert(newIndex, item);
                              });

                              context.read<UpdateTasksOrderBloc>().add(
                                UpdateTaskOrderRequested(tasks: _localTasks),
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _localTasks.length,
                            itemBuilder: (context, index) {
                              final task = _localTasks[index];
                              return _buildDismissibleTask(
                                task,
                                index,
                                colorScheme,
                                l10n,
                                false,
                              );
                            },
                          ),
                  ),
                ],
              );
            default:
              return Center(child: Text(l10n.emptyTask));
          }
        },
      ),
    );
  }
}
