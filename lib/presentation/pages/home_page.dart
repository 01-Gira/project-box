import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/presentation/bloc/dashboard_stats/dashboard_stats_bloc.dart';
import 'package:project/presentation/bloc/get_project_items/get_project_items_bloc.dart';
import 'package:project_box/presentation/widgets/banner_images.dart';
import 'package:project_box/presentation/widgets/next_task_section.dart';
import 'package:project_box/presentation/widgets/recent_projects.dart';
import 'package:project_box/presentation/widgets/stats_info_section.dart';
import 'package:project_box/presentation/widgets/task_completion_chart.dart';
import 'package:project_box/presentation/widgets/calendar_widget.dart';
import 'package:task/presentation/bloc/next_tasks/next_tasks_bloc.dart';
import 'package:task/presentation/bloc/search_tasks/search_tasks_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:convert';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:project_box/injection.dart' as di;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final DatabaseHelper _db = di.locator<DatabaseHelper>();

  Future<void> _exportData() async {
    final l10n = AppLocalizations.of(context)!;
    final projects = await _db.getProjects(null);
    final List<Map<String, dynamic>> data = [];
    for (final p in projects) {
      final full = await _db.getProjectById(p['id'] as int);
      data.add(full);
    }
    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/project_box_export.json');
    await file.writeAsString(jsonEncode(data));
    await Share.shareXFiles([XFile(file.path)], text: l10n.projectBoxExport);
  }

  Future<void> _importData() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null) return;
    final path = result.files.single.path;
    if (path == null) return;
    final content = await File(path).readAsString();
    final List<dynamic> data = jsonDecode(content) as List<dynamic>;
    final existing = await _db.getProjects(null);
    int nextId = existing.isEmpty
        ? 1
        : existing
                  .map<int>((e) => e['id'] as int)
                  .reduce((a, b) => a > b ? a : b) +
              1;
    for (final raw in data) {
      final map = Map<String, dynamic>.from(raw as Map);
      final tasks = List<Map<String, dynamic>>.from(map.remove('tasks') ?? []);
      final logs = List<Map<String, dynamic>>.from(map.remove('logs') ?? []);
      map['id'] = nextId;
      await _db.insertProject(map);
      for (final t in tasks) {
        t.remove('id');
        await _db.insertTask(nextId, t);
      }
      for (final l in logs) {
        l.remove('id');
        await _db.insertProgressLog(nextId, l);
      }
      nextId++;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<GetProjectItemsBloc>().add(FetchProjectItems(limit: 5));
        context.read<NextTasksBloc>().add(FetchNextTasks());
        context.read<DashboardStatsBloc>().add(FetchDashboardStats());
        context.read<SearchTasksBloc>().add(const SearchTasksRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: l10n.export,
            onPressed: _exportData,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: l10n.import,
            onPressed: _importData,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BannerImages(height: 180),
            const SizedBox(height: 16),
            const StatsInfoSection(),
            const SizedBox(height: 16),
            const TaskCompletionChart(),
            const SizedBox(height: 16),
            const CalendarWidget(),
            const SizedBox(height: 16),
            NextTaskSection(),
            const SizedBox(height: 16),
            RecentProjectsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/project/create');
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        tooltip: l10n.createProjectTitle,
        child: const Icon(Icons.add),
      ),
    );
  }
}
