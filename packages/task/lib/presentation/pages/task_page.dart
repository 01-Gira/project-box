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

class TaskPage extends StatefulWidget {
  final int projectId;
  const TaskPage({super.key, required this.projectId});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> _localTasks = [];

  @override
  void initState() {
    super.initState();
    context.read<GetTasksForProjectBloc>().add(
      FetchTasksItems(id: widget.projectId),
    );
  }

  Future<void> _showEditTaskDialog(Task task, AppLocalizations l10n) async {
    final TextEditingController editController = TextEditingController(
      text: task.title,
    );
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                controller: editController,
                decoration: InputDecoration(labelText: l10n.taskTitleLabel),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop({'title': editController.text.trim()}),
                child: Text(l10n.save),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
    if (result != null) {
      final String newTitle = result['title'];

      if (mounted) {
        context.read<UpdateTaskBloc>().add(
          UpdateTaskRequested(id: task.id, title: newTitle),
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

              return ReorderableListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _localTasks.length,
                itemBuilder: (context, index) {
                  final task = _localTasks[index];

                  return Dismissible(
                    key: ValueKey(task.id),
                    background: Container(
                      color: colorScheme.primary,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.edit_outlined,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: colorScheme.error,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.delete_outline,
                        color: colorScheme.onError,
                      ),
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
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(l10n.cancel),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
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
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final Task item = _localTasks.removeAt(oldIndex);
                    _localTasks.insert(newIndex, item);
                  });

                  context.read<UpdateTasksOrderBloc>().add(
                    UpdateTaskOrderRequested(tasks: _localTasks),
                  );
                },
              );
            default:
              return Center(child: Text(l10n.emptyTask));
          }
        },
      ),
    );
  }
}
