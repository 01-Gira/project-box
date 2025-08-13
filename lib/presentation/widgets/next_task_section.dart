import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/domain/entities/task_with_project_info.dart'; // Impor entitas baru Anda
import 'package:task/presentation/bloc/next_tasks/next_tasks_bloc.dart'; // BLoC baru Anda
import 'package:task/presentation/bloc/update_task_status/update_task_status_bloc.dart';

class NextTaskSection extends StatelessWidget {
  const NextTaskSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.nextTask,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<NextTasksBloc, NextTasksState>(
              builder: (context, state) {
                switch (state.state) {
                  case RequestState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case RequestState.error:
                    return Center(
                      child: Text(
                        'Gagal memuat proyek: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  case RequestState.loaded:
                    final tasks = state.tasks ?? [];

                    return ListView.separated(
                      shrinkWrap: true, // Penting di dalam Column
                      physics:
                          const NeverScrollableScrollPhysics(), // Agar tidak bisa di-scroll sendiri
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final taskWithInfo = tasks[index];
                        return _buildTaskItem(context, taskWithInfo);
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    TaskWithProjectInfo taskWithInfo,
  ) {
    final task = taskWithInfo.task;
    final projectName = taskWithInfo.projectName;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: task.isCompleted == 1,
        onChanged: (bool? newValue) {
          if (newValue != null) {
            context.read<UpdateTaskStatusBloc>().add(
              UpdateTaskStatusRequested(id: task.id, isCompleted: newValue),
            );
          }
        },
      ),
      title: Text(
        task.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'dari: $projectName',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios, size: 16),
        onPressed: () {
          // Navigasi ke halaman detail proyek terkait
          // context.go('/project-details/${task.pro}');
        },
      ),
    );
  }
}
