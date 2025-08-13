import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/domain/enitites/project.dart';
import 'package:project/presentation/bloc/get_project_items/get_project_items_bloc.dart';
import 'package:project/presentation/bloc/remove_projects/remove_projects_bloc.dart';
import 'package:project/presentation/bloc/update_projects_status/update_projects_status_bloc.dart';
import 'package:project/presentation/widgets/project_card.dart';

class SearchProjectPage extends StatefulWidget {
  const SearchProjectPage({super.key});

  @override
  State<SearchProjectPage> createState() => _SearchProjectPageState();
}

class _SearchProjectPageState extends State<SearchProjectPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Project> _allProjects = [];
  List<Project> _filteredProjects = [];

  final Set<String> _selectedStatuses = <String>{};
  final List<String> _statusOptions = ['Planned', 'Active', 'Done'];

  bool _isSelectionMode = false;
  final Set<int> _selectedProjectIds = <int>{};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_triggerFilter);
    context.read<GetProjectItemsBloc>().add(const FetchProjectItems());
  }

  @override
  void dispose() {
    _searchController.removeListener(_triggerFilter);
    _searchController.dispose();
    super.dispose();
  }

  void _triggerFilter() {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _allProjects.where((project) {
      final nameMatch = project.name.toLowerCase().contains(query);

      final statusMatch =
          _selectedStatuses.isEmpty ||
          _selectedStatuses.contains(project.status);

      return nameMatch && statusMatch;
    }).toList();

    setState(() {
      _filteredProjects = filtered;
    });
  }

  void _toggleSelection(int projectId) {
    setState(() {
      if (_selectedProjectIds.contains(projectId)) {
        _selectedProjectIds.remove(projectId);
      } else {
        _selectedProjectIds.add(projectId);
      }
      if (_selectedProjectIds.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _enterSelectionMode(int projectId) {
    setState(() {
      _isSelectionMode = true;
      _selectedProjectIds.add(projectId);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedProjectIds.clear();
    });
  }

  void _deleteSelectedProjects() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteProject),
        content: Text(l10n.projectDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<RemoveProjectsBloc>().add(
                DeleteProjectsRequested(ids: _selectedProjectIds.toList()),
              );

              _exitSelectionMode();
              Navigator.of(ctx).pop();
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

  void _changeStatusOfSelectedProjects() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.changeStatus),
        content: DropdownButton<String>(
          value: 'Active', // Default
          items: _statusOptions
              .map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              )
              .toList(),
          onChanged: (newStatus) {
            if (newStatus != null) {
              context.read<UpdateProjectsStatusBloc>().add(
                UpdateProjectsStatusRequested(
                  ids: _selectedProjectIds.toList(),
                  newStatus: newStatus,
                ),
              );
              _exitSelectionMode();
              Navigator.of(ctx).pop();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: _isSelectionMode
          ? _buildContextualAppBar()
          : AppBar(title: Text(l10n.allProject)),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GetProjectItemsBloc, GetProjectItemsState>(
            listener: (context, state) {
              if (state.state == RequestState.loaded) {
                final projects = state.projects ?? [];
                setState(() {
                  _allProjects = projects;
                  _filteredProjects = projects;
                });
              }
            },
          ),
        ],
        child: Column(
          children: [
            if (!_isSelectionMode)
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
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      children: _statusOptions.map((status) {
                        final isSelected = _selectedStatuses.contains(status);
                        return FilterChip(
                          label: Text(status),
                          selected: isSelected,
                          selectedColor: colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                          ),
                          checkmarkColor: colorScheme.onPrimaryContainer,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedStatuses.add(status);
                              } else {
                                _selectedStatuses.remove(status);
                              }
                            });
                            _triggerFilter();
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: BlocBuilder<GetProjectItemsBloc, GetProjectItemsState>(
                builder: (context, state) {
                  if (state.state == RequestState.loading &&
                      _allProjects.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.state == RequestState.error) {
                    return Center(child: Text(l10n.somethingWentWrong));
                  }
                  if (_filteredProjects.isEmpty) {
                    return Center(child: Text(l10n.projectNotFound));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredProjects.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      final isSelected = _selectedProjectIds.contains(
                        project.id,
                      );
                      return GestureDetector(
                        onLongPress: () {
                          if (!_isSelectionMode) {
                            _enterSelectionMode(project.id);
                          }
                        },
                        onTap: () {
                          if (_isSelectionMode) {
                            _toggleSelection(project.id);
                          } else {
                            context.push('/project/${project.id}');
                          }
                        },
                        child: ProjectCard(
                          project: project,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildContextualAppBar() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      // --- PERUBAHAN THEME ---
      backgroundColor: colorScheme.onPrimary,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: _exitSelectionMode,
      ),
      title: Text(_selectedProjectIds.length.toString()),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: l10n.changeStatus,
          onPressed: _changeStatusOfSelectedProjects,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: l10n.delete,
          onPressed: _deleteSelectedProjects,
        ),
      ],
    );
  }
}
