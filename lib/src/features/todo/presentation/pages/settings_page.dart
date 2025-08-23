import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/src/features/todo/presentation/bloc/theme/theme_bloc.dart';
import 'package:to_do_app/src/features/todo/presentation/widgets/theme_selection_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return ListTile(
                leading: Icon(getThemeIcon(state.themeMode, context)),
                title: Text('Mode Tampilan'),
                subtitle: Text(_themeModeToString(state.themeMode)),
                onTap: () {
                  _showThemeDialog(context);
                },
              );
            },
          ),
          Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Bahasa'),
            subtitle: const Text('Indonesia'),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          Divider(height: 1, indent: 16, endIndent: 16),
          SwitchListTile(
            value: true,

            onChanged: (bool valaue) {},
            title: Text('Notifikasi Push'),
            secondary: Icon(Icons.notifications_outlined),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Tema'),
          content: ThemeSelectionDialog(
            initialThemeMode: context.read<ThemeBloc>().state.themeMode,
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Pilih Bahasa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Indonesia'),
                onTap: () {
                  // TODO: Implementasi logika ganti bahasa ke Indonesia
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  // TODO: Implementasi logika ganti bahasa ke Inggris
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      case ThemeMode.system:
        return 'Sesuai Sistem';
    }
  }

  IconData getThemeIcon(ThemeMode themeMode, BuildContext context) {
    // Cek tema sistem secara spesifik
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.system:
        // Jika tema sistem, cek apakah sistem sedang dark mode atau tidak
        return isDarkMode
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined;
    }
  }
}
