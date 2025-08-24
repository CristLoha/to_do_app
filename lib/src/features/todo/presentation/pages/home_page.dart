import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:to_do_app/src/features/todo/presentation/pages/add_edit_task_page.dart';
import '../widgets/adaptive_app_bar.dart';
import '../widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data dummy untuk tugas
  final List<Todo> _tasks = [
    Todo(id: '1', title: 'Siapkan presentasi untuk meeting besok'),
    Todo(
      id: '2',
      title: 'Beli susu dan telur di supermarket',
      isCompleted: true,
    ),
    Todo(id: '3', title: 'Belajar Flutter Clean Architecture'),
    Todo(id: '4', title: 'Follow up client project A'),
    Todo(id: '5', title: 'Desain ulang landing page'),
    Todo(id: '6', title: 'Perbaiki bug di halaman login'),
  ];

  // Palet warna modern yang akan kita gunakan secara acak
  final List<Color> _taskColors = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.teal.shade100,
  ];

  // Fungsi PINTAR untuk memilih metode navigasi
  void _navigateToTaskScreen(BuildContext context, Todo? task) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double mobileBreakpoint = 700;

    if (screenWidth < mobileBreakpoint) {
      final taskId = task?.id ?? 'new';
      context.go('/task/$taskId');
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AddEditTaskPage(task: task),
              ),
            ),
          );
        },
      );
    }
  }

  // Fungsi untuk menghapus tugas
  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
    // Menampilkan notifikasi singkat setelah menghapus
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tugas telah dihapus')));
  }

  // Fungsi untuk menangani aksi dari PopupMenu
  void _handleTaskAction(TaskAction action, Todo task) {
    switch (action) {
      case TaskAction.toggleComplete:
        setState(() {
          final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
          if (taskIndex != -1) {
            _tasks[taskIndex] = _tasks[taskIndex].copyWith(
              isCompleted: !task.isCompleted,
            );
          }
        });
        break;
      case TaskAction.edit:
        _navigateToTaskScreen(context, task);
        break;
      case TaskAction.delete:
        _deleteTask(task.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Memisahkan tugas aktif dan yang sudah selesai
    final activeTasks = _tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = _tasks.where((task) => task.isCompleted).toList();
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Tugas Hari Ini'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header halaman
          _buildHeader(context, activeTasks.length),

          // Sliver 2: Daftar Tugas Aktif
          _buildActiveTaskList(context, activeTasks),

          // Sliver 3: Dropdown untuk Tugas Selesai
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: ExpansionTile(
                title: Text(
                  'Selesai (${completedTasks.length})',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                children: _buildCompletedTaskList(context, completedTasks),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isDesktop
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _navigateToTaskScreen(context, null),
              label: const Text('Tugas Baru'),
              icon: const Icon(Icons.add),
            ),
    );
  }

  // WIDGET HELPER BARU: Untuk membuat header
  Widget _buildHeader(BuildContext context, int activeTaskCount) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 24.0,
        right: 24.0,
        bottom: 16.0,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tugas Aktif ($activeTaskCount)',
              style: GoogleFonts.inter(
                fontSize: isDesktop ? 28 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isDesktop)
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari tugas...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.tonalIcon(
                    onPressed: () => _navigateToTaskScreen(context, null),
                    icon: const Icon(Icons.add),
                    label: const Text('Tugas Baru'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Untuk membuat daftar tugas aktif (sebagai SLIVER)
  Widget _buildActiveTaskList(BuildContext context, List<Todo> tasks) {
    if (tasks.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Text(
              'Tidak ada tugas aktif, hore!',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    // REVISI TOTAL: Menggunakan SliverGrid untuk semua ukuran layar
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280.0,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final task = tasks[index];
          final color = _taskColors[index % _taskColors.length];
          return TaskListItem(
            task: task,
            color: color,
            onActionSelected: (action) => _handleTaskAction(action, task),
          );
        }, childCount: tasks.length),
      ),
    );
  }

  // WIDGET HELPER BARU: Untuk membuat daftar tugas selesai (sebagai LIST WIDGET BIASA)
  List<Widget> _buildCompletedTaskList(BuildContext context, List<Todo> tasks) {
    if (tasks.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Belum ada tugas yang selesai',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ];
    }

    return [
      GridView.builder(
        padding: const EdgeInsets.only(top: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280.0,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final color = Colors.grey.shade300;
          return TaskListItem(
            task: task,
            color: color,
            onActionSelected: (action) => _handleTaskAction(action, task),
          );
        },
      ),
    ];
  }
}
