import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Settings',
        style: theme.textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Theme Mode Toggle
          ListTile(
            title: Text(
              'Dark Mode',
              style: theme.textTheme.bodyLarge,
            ),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: themeProvider.themeMode == ThemeMode.light ? theme.colorScheme.primary : theme.colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}