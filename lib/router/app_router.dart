import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/presentation/pages/create_project_page.dart';
import 'package:project/presentation/pages/detail_project_page.dart';
import 'package:project/presentation/pages/edit_project_page.dart';
import 'package:project/presentation/pages/search_project_page.dart';
import 'package:task/presentation/pages/search_task_page.dart';

import 'package:project_box/presentation/pages/home_page.dart';

class AppRouter {
  AppRouter._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(
        path: '/search',
        builder: (context, state) => SearchProjectPage(),
      ),
      GoRoute(
        path: '/tasks/search',
        builder: (context, state) => const SearchTaskPage(),
      ),

      GoRoute(
        path: '/project/create',
        builder: (context, state) => CreateProjectPage(),
      ),
      GoRoute(
        path: '/project/:id',
        builder: (context, state) {
          final String? idString = state.pathParameters['id'];

          final int projectId = int.tryParse(idString ?? '') ?? 0;

          return DetailProjectPage(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/project/:id/edit',
        builder: (context, state) {
          final String? idString = state.pathParameters['id'];

          final int projectId = int.tryParse(idString ?? '') ?? 0;

          return EditProjectPage(projectId: projectId);
        },
      ),
    ],

    // errorBuilder: (context, state) => const Text("Halaman tidak ditemukan"),
  );
}
