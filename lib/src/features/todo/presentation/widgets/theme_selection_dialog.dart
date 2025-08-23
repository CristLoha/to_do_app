import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_bloc.dart';

class ThemeSelectionDialog extends StatefulWidget {
  final ThemeMode initialThemeMode;
  const ThemeSelectionDialog({super.key, required this.initialThemeMode});

  @override
  State<ThemeSelectionDialog> createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  late ThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.initialThemeMode;
  }

  void _handleThemeChange(ThemeMode? value) {
    if (value != null) {
      setState(() {
        _selectedTheme = value;
      });
      context.read<ThemeBloc>().add(ThemeChanged(themeMode: value));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup<ThemeMode>(
      groupValue: _selectedTheme,
      onChanged: _handleThemeChange,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Terang'),
            leading: Radio<ThemeMode>(value: ThemeMode.light),
            onTap: () => _handleThemeChange(ThemeMode.light),
          ),
          ListTile(
            title: const Text('Gelap'),
            leading: Radio<ThemeMode>(value: ThemeMode.dark),
            onTap: () => _handleThemeChange(ThemeMode.dark),
          ),
          ListTile(
            title: const Text('Sesuai Sistem'),
            leading: Radio<ThemeMode>(value: ThemeMode.system),
            onTap: () => _handleThemeChange(ThemeMode.system),
          ),
        ],
      ),
    );
  }
}
