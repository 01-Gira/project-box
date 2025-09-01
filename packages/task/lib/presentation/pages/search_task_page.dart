import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task/presentation/bloc/search_tasks/search_tasks_bloc.dart';

class SearchTaskPage extends StatefulWidget {
  const SearchTaskPage({super.key});

  @override
  State<SearchTaskPage> createState() => _SearchTaskPageState();
}

class _SearchTaskPageState extends State<SearchTaskPage> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  final Set<String> _selectedStatuses = <String>{};
  final List<String> _statusOptions = ['Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_triggerSearch);
    _triggerSearch();
  }

  @override
  void dispose() {
    _searchController.removeListener(_triggerSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    bool? isCompleted;
    if (_selectedStatuses.length == 1) {
      isCompleted = _selectedStatuses.contains('Completed');
    }
    context.read<SearchTasksBloc>().add(
      SearchTasksRequested(
        query: _searchController.text,
        dueDate: _selectedDate,
        isCompleted: isCompleted,
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    setState(() {
      _selectedDate = picked;
    });
    _triggerSearch();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.search)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.search,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: Text(
                        _selectedDate != null
                            ? DateFormat.yMd().format(_selectedDate!)
                            : 'Due Date',
                      ),
                      selected: _selectedDate != null,
                      onSelected: (_) => _pickDate(),
                      onDeleted: _selectedDate != null
                          ? () {
                              setState(() => _selectedDate = null);
                              _triggerSearch();
                            }
                          : null,
                    ),
                    ..._statusOptions.map(
                      (status) => FilterChip(
                        label: Text(status),
                        selected: _selectedStatuses.contains(status),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedStatuses.add(status);
                            } else {
                              _selectedStatuses.remove(status);
                            }
                          });
                          _triggerSearch();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchTasksBloc, SearchTasksState>(
              builder: (context, state) {
                switch (state.state) {
                  case RequestState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case RequestState.error:
                    return Center(child: Text(state.message ?? ''));
                  case RequestState.loaded:
                    final tasks = state.tasks;
                    if (tasks.isEmpty) {
                      return Center(child: Text(l10n.emptyTask));
                    }
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final item = tasks[index];
                        final task = item.task;
                        return ListTile(
                          title: Text(task.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.fromProject(item.projectName)),
                              if (task.dueDate != null)
                                Text(
                                  DateFormat.yMd().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      task.dueDate!,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: task.isCompleted == 1
                              ? const Icon(Icons.check)
                              : null,
                        );
                      },
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
