import 'dart:io';
import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_log/presentation/bloc/create_progress_log/create_progress_log_bloc.dart';

import 'package:project/domain/enitites/project.dart';
import 'package:project/presentation/bloc/get_project_by_id/get_project_by_id_bloc.dart';
import 'package:project/presentation/bloc/remove_project_by_id/remove_project_by_id_bloc.dart';
import 'package:task/presentation/bloc/create_task/create_task_bloc.dart';

import 'package:task/presentation/pages/task_page.dart';
import 'package:progress_log/presentation/pages/progress_log_page.dart';

class DetailProjectPage extends StatefulWidget {
  final int projectId;

  const DetailProjectPage({super.key, required this.projectId});

  @override
  State<DetailProjectPage> createState() => _DetailProjectPageState();
}

class _DetailProjectPageState extends State<DetailProjectPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _logTextController = TextEditingController();
  File? _logImageFile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    context.read<GetProjectByIdBloc>().add(
      FetchProjectItemById(id: widget.projectId),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskTitleController.dispose();
    _logTextController.dispose();
    super.dispose();
  }

  void _removeProject() {
    context.read<RemoveProjectByIdBloc>().add(
      RemoveProjectItemById(id: widget.projectId),
    );
  }

  void _saveTask() {
    final title = _taskTitleController.text.trim();
    if (title.isNotEmpty) {
      context.read<CreateTaskBloc>().add(
        TaskSubmitted(title: title, projectId: widget.projectId),
      );
      _taskTitleController.clear();
      Navigator.pop(context);
    }
  }

  Future<void> _pickLogImage(StateSetter setState) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _logImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToPickImage(e.toString()),
            ),
          ),
        );
      }
    }
  }

  void _saveProgressLog() {
    final text = _logTextController.text.trim();
    if (text.isNotEmpty || _logImageFile != null) {
      context.read<CreateProgressLogBloc>().add(
        ProgressLogSubmitted(
          logText: text,
          imagePath: _logImageFile?.path,
          projectId: widget.projectId,
        ),
      );
      _logTextController.clear();
      setState(() {
        _logImageFile = null;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<RemoveProjectByIdBloc, RemoveProjectByIdState>(
          listener: (context, state) {
            if (state.state == RequestState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.somethingWentWrong),
                  backgroundColor: colorScheme.error,
                ),
              );
            }

            if (state.state == RequestState.loaded) {
              context.go('/home');
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<GetProjectByIdBloc, GetProjectByIdState>(
          builder: (context, state) {
            switch (state.state) {
              case RequestState.loading:
                return const Center(child: CircularProgressIndicator());
              case RequestState.error:
                return Center(child: Text(state.message!));
              case RequestState.loaded:
                final project = state.project;

                if (project == null) {
                  return Center(child: Text(l10n.projectNotFound));
                }

                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      _buildSliverAppBar(context, innerBoxIsScrolled, project),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      TaskPage(projectId: widget.projectId),
                      ProgressLogPage(projectId: widget.projectId),
                      _InfoView(project: project),
                    ],
                  ),
                );
              default:
                return Center(child: Text(l10n.projectNotFound));
            }
          },
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _tabController.animation!,
          builder: (context, child) {
            final tabIndex = (_tabController.animation?.value ?? 0).round();
            Widget? fab;

            switch (tabIndex) {
              case 0:
                fab = FloatingActionButton.extended(
                  onPressed: () => _showAddTaskSheet(context),
                  label: Text(l10n.addTask),
                  icon: const Icon(Icons.add_task),
                  heroTag: 'fab_tugas',
                );
                break;
              case 1:
                fab = FloatingActionButton.extended(
                  onPressed: () => _showAddLogSheet(context),
                  label: Text(l10n.addLog),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  heroTag: 'fab_log',
                );
                break;
              default:
                fab = null;
                break;
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: fab,
            );
          },
        ),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.addTask, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: _taskTitleController,
                decoration: InputDecoration(labelText: l10n.taskTitleLabel),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _saveTask, child: Text(l10n.save)),
            ],
          ),
        );
      },
    );
  }

  void _showAddLogSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.addLog,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (_logImageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _logImageFile!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                TextButton.icon(
                  onPressed: () => _pickLogImage(setState),
                  icon: const Icon(Icons.image_outlined),
                  label: Text(
                    _logImageFile == null
                        ? l10n.choosePicture
                        : l10n.changePicture,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _logTextController,
                  decoration: InputDecoration(labelText: l10n.logNoteLabel),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveProgressLog,
                  child: Text(l10n.save),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    bool isScrolled,
    Project project,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 250.0,
      floating: true,
      pinned: true,
      elevation: 2.0,
      forceElevated: isScrolled,
      backgroundColor: colorScheme.surface,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            context.push('/project/${widget.projectId}/edit');
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.confirmDelete),
                  content: Text(l10n.projectDeleteConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _removeProject();
                      },
                      child: Text(
                        l10n.delete,
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'delete',
              child: Text(
                l10n.deleteProject,
                style: TextStyle(color: colorScheme.error),
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          project.name,
          style: theme.textTheme.titleLarge?.copyWith(
            color: isScrolled ? colorScheme.onSurface : Colors.white,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 56),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image:
                  (project.coverImage != null &&
                      project.coverImage!.startsWith('http'))
                  ? NetworkImage(project.coverImage!)
                  : FileImage(File(project.coverImage ?? '')) as ImageProvider,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: colorScheme.surfaceVariant),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.8),
                  end: Alignment.center,
                  colors: <Color>[Color(0x60000000), Color(0x00000000)],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(text: l10n.task, icon: const Icon(Icons.check_circle_outline)),
          Tab(text: l10n.log, icon: const Icon(Icons.photo_library_outlined)),
          Tab(text: l10n.info, icon: const Icon(Icons.info_outline)),
        ],
      ),
    );
  }
}

class _InfoView extends StatelessWidget {
  final Project project;
  const _InfoView({required this.project});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          l10n.projectDescription,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(project.description, style: theme.textTheme.bodyMedium),
        const Divider(height: 40),
        _InfoTile(
          icon: Icons.label_outline,
          title: 'Status',
          subtitle: project.status,
        ),
        _InfoTile(
          icon: Icons.calendar_today_outlined,
          title: l10n.createdDate,
          subtitle: DateFormat('d MMMM yyyy').format(project.creationDate!),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
