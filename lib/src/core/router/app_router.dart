import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/src/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:to_do_app/src/features/todo/presentation/pages/add_edit_task_page.dart';
import 'package:to_do_app/src/features/todo/presentation/pages/dashboard_page.dart';
import 'package:to_do_app/src/features/todo/presentation/pages/home_page.dart';
import 'package:to_do_app/src/features/todo/presentation/pages/settings_page.dart';
import 'package:to_do_app/src/features/todo/presentation/widgets/task_list_item.dart';
import '../../features/todo/presentation/pages/scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  path: '/task/:id', // Path diubah menjadi absolute
                  // parentNavigatorKey memastikan rute ini menggunakan navigator utama,
                  // sehingga tampil di atas ShellRoute.
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final String id = state.pathParameters['id']!;
                    // Logika untuk membedakan mode edit atau tambah
                    // Nanti ini akan mengambil data task dari BLoC berdasarkan ID
                    final Todo? task = (id == 'new')
                        ? null
                        : null; // Placeholder
                    return AddEditTaskPage(task: task);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pomodoro',
              builder: (context, state) => PomodoroPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),

    // Rute untuk halaman CRUD yang akan tampil menutupi seluruh layar
  ],
);
