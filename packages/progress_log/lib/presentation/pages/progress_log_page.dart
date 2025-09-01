import 'dart:io';
import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_log/domain/entities/progress_log.dart';
import 'package:progress_log/presentation/bloc/create_progress_log/create_progress_log_bloc.dart';
import 'package:progress_log/presentation/bloc/get_progress_logs/get_progress_logs_for_project_bloc.dart';
import 'package:progress_log/presentation/bloc/remove_progress_log/remove_progress_log_bloc.dart';
import 'package:progress_log/presentation/bloc/update_progress_log/update_progress_log_bloc.dart';
import 'package:progress_log/presentation/widgets/progress_log_card.dart';
import 'package:progress_log/presentation/widgets/progress_log_chart.dart';
import 'package:image_picker/image_picker.dart';

class ProgressLogPage extends StatefulWidget {
  final int projectId;
  const ProgressLogPage({super.key, required this.projectId});

  @override
  State<ProgressLogPage> createState() => _ProgressLogState();
}

class _ProgressLogState extends State<ProgressLogPage> {
  List<ProgressLog> _localProgressLogs = [];

  @override
  void initState() {
    super.initState();
    context.read<GetProgressLogsForProjectBloc>().add(
      FetchProgressLogItems(id: widget.projectId),
    );
  }

  Future<void> _showEditLogDialog(
    ProgressLog log,
    AppLocalizations l10n,
  ) async {
    final TextEditingController editController = TextEditingController(
      text: log.logText,
    );
    File? newImageFile;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
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
                Text(l10n.edit, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                if (newImageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      newImageFile!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else if (log.imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(log.imagePath!),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                TextButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        newImageFile = File(pickedFile.path);
                      });
                    }
                  },
                  icon: const Icon(Icons.image_outlined),
                  label: Text(
                    newImageFile != null || log.imagePath != null
                        ? l10n.changePicture
                        : l10n.choosePicture,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: editController,
                  decoration: InputDecoration(labelText: l10n.logNoteLabel),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop({
                    'text': editController.text.trim(),
                    'image': newImageFile,
                  }),
                  child: Text(l10n.save),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (result != null) {
      final String newText = result['text'];
      final File? newImage = result['image'];

      if (mounted) {
        context.read<UpdateProgressLogBloc>().add(
          UpdateProgressLogRequested(
            logId: log.id,
            logText: newText,
            imagePath: newImage?.path,
          ),
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
        BlocListener<
          GetProgressLogsForProjectBloc,
          GetProgressLogsForProjectState
        >(
          listener: (context, state) {
            if (state.state == RequestState.loaded) {
              setState(() {
                _localProgressLogs = state.logs ?? [];
              });
            }
          },
        ),
        BlocListener<CreateProgressLogBloc, CreateProgressLogState>(
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
        BlocListener<UpdateProgressLogBloc, UpdateProgressLogState>(
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
      child:
          BlocBuilder<
            GetProgressLogsForProjectBloc,
            GetProgressLogsForProjectState
          >(
            builder: (context, state) {
              switch (state.state) {
                case RequestState.loading:
                  return const Center(child: CircularProgressIndicator());
                case RequestState.error:
                  return Center(child: Text(state.message!));
                case RequestState.loaded:
                  if (_localProgressLogs.isEmpty) {
                    return Center(child: Text(l10n.emptyLog));
                  }

                  return DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: l10n.logs),
                            Tab(text: l10n.stats),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                padding: const EdgeInsets.all(16.0),
                                itemCount: _localProgressLogs.length,
                                itemBuilder: (context, index) {
                                  final log = _localProgressLogs[index];

                                  return Dismissible(
                                    key: ValueKey(log.id),
                                    background: Container(
                                      color: colorScheme.primary,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                      color: colorScheme.error,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: colorScheme.onError,
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.startToEnd) {
                                        await _showEditLogDialog(log, l10n);
                                        return false;
                                      } else {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(l10n.confirmDelete),
                                              content: Text(
                                                l10n.confirmationDelete,
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                                  child: Text(l10n.cancel),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                                  child: Text(
                                                    l10n.delete,
                                                    style: TextStyle(
                                                      color: colorScheme.error,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    onDismissed: (direction) {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        context
                                            .read<RemoveProgressLogBloc>()
                                            .add(
                                              DeleteProgressLogRequested(
                                                logId: log.id,
                                              ),
                                            );
                                        setState(() {
                                          _localProgressLogs.removeAt(index);
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ProgressLogCard(log: log),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ProgressLogChart(
                                  logs: _localProgressLogs,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                default:
                  return Center(child: Text(l10n.emptyLog));
              }
            },
          ),
    );
  }
}
