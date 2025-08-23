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

  // Fungsi PINTAR untuk memilih metode navigasi
  void _navigateToTaskScreen(BuildContext context, Todo? task) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double mobileBreakpoint = 700;

    // Jika layar kecil (mobile), gunakan GoRouter untuk halaman layar penuh
    if (screenWidth < mobileBreakpoint) {
      final taskId = task?.id ?? 'new';
      context.go('/task/$taskId');
    } else {
      // Jika layar besar (desktop/web), tampilkan sebagai modal dialog
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // Batasi lebar dialog agar tidak terlalu besar di layar lebar
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
              // Kita bungkus dengan ClipRRect agar konten di dalamnya juga rounded
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AdaptiveAppBar akan otomatis hilang di desktop
      appBar: AdaptiveAppBar(
        title: const Text('Tugas Hari Ini'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ),
        ],
      ),
      // REVISI TOTAL: Menggunakan CustomScrollView tanpa Center & ConstrainedBox
      // agar konten bisa mengisi layar dari kiri ke kanan.
      body: CustomScrollView(
        slivers: [
          // Header ini akan selalu ada, tapi paddingnya adaptif.
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 24.0,
              right: 24.0,
              bottom: 16.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tugas Terakhir', // Mengganti judul agar lebih deskriptif
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Search Bar hanya muncul di desktop
                  if (MediaQuery.of(context).size.width > 900)
                    SizedBox(
                      width: 250, // Batasi lebar search bar
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
                          ).colorScheme.surfaceVariant.withOpacity(0.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // GridView sekarang diubah menjadi SliverGrid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 450.0,
                mainAxisSpacing: 24.0,
                crossAxisSpacing: 24.0,
                childAspectRatio: 4 / 1.2,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final task = _tasks[index];
                return TaskListItem(
                  task: task,
                  onChanged: (value) {
                    setState(() {
                      final updatedTask = Todo(
                        id: task.id,
                        title: task.title,
                        isCompleted: value ?? false,
                      );
                      _tasks[index] = updatedTask;
                    });
                  },
                  onTap: () => _navigateToTaskScreen(context, task),
                );
              }, childCount: _tasks.length),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToTaskScreen(context, null),
        label: const Text('Tugas Baru'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
