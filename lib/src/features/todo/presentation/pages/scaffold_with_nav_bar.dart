import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double mobileBreakpoint = 700;
        final bool isMobile = constraints.maxWidth < mobileBreakpoint;

        // Tampilan untuk Desktop / Tablet (Layout Admin Dashboard)
        if (!isMobile) {
          return Scaffold(
            body: Row(
              children: [
                // REVISI: Menggunakan Card untuk sidebar yang lebih modern
                Card(
                  elevation: 2.0, // Memberi bayangan yang halus
                  margin:
                      EdgeInsets.zero, // Menghilangkan margin default dari Card
                  shape: const RoundedRectangleBorder(
                    // Menghilangkan sudut rounded
                    borderRadius: BorderRadius.zero,
                  ),
                  child: SizedBox(
                    width: 250, // Lebar menu samping
                    child: Column(
                      children: [
                        // Header untuk menu
                        SizedBox(
                          height: 120,
                          child: Center(
                            child: Text(
                              'To-Do 2025',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // REVISI: Menambahkan padding di sekitar item navigasi
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              _buildNavItem(
                                context,
                                icon: Icons.task_alt_outlined,
                                text: 'Tugas',
                                index: 0,
                              ),
                              _buildNavItem(
                                context,
                                icon: Icons.timer_outlined,
                                text: 'Pomodoro',
                                index: 1,
                              ),
                              _buildNavItem(
                                context,
                                icon: Icons.insights_outlined,
                                text: 'Dashboard',
                                index: 2,
                              ),
                              _buildNavItem(
                                context,
                                icon: Icons.settings_outlined,
                                text: 'Pengaturan',
                                index: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Expanded agar konten utama mengisi sisa ruang
                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        // Tampilan untuk Mobile
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.task_alt_outlined),
                activeIcon: Icon(Icons.task_alt),
                label: 'Tugas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timer_outlined),
                activeIcon: Icon(Icons.timer),
                label: 'Pomodoro',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insights_outlined),
                activeIcon: Icon(Icons.insights),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Pengaturan',
              ),
            ],
            currentIndex: navigationShell.currentIndex,
            onTap: (int index) => _onTap(context, index),
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }

  // Widget helper untuk membuat item navigasi agar kode lebih rapi
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required int index,
  }) {
    final bool isSelected = navigationShell.currentIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      onTap: () => _onTap(context, index),
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // REVISI: Mengurangi padding horizontal agar lebih pas di dalam container baru
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
