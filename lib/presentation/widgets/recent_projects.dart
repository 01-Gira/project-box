import 'package:core/common/state_enum.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/presentation/bloc/get_project_items/get_project_items_bloc.dart';
import 'package:project/presentation/widgets/project_card.dart';

class RecentProjectsSection extends StatelessWidget {
  const RecentProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header Bagian ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.recentProjects,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push('/search');
                },
                child: Text(AppLocalizations.of(context)!.seeAll),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 240,
          child: BlocBuilder<GetProjectItemsBloc, GetProjectItemsState>(
            builder: (context, state) {
              // --- State Loading ---
              switch (state.state) {
                case RequestState.loading:
                  return const Center(child: CircularProgressIndicator());
                case RequestState.loaded:
                  final projects = state.projects ?? [];

                  final limitedProjects = projects.take(5).toList();
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: limitedProjects.length,
                    itemBuilder: (context, index) {
                      final project = limitedProjects[index];

                      return GestureDetector(
                        onTap: () {
                          context.push('/project/${project.id}');
                        },
                        child: ProjectCard(project: project),
                      );
                    },
                  );
                case RequestState.error:
                  return Center(
                    child: Text(
                      'Gagal memuat proyek: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
