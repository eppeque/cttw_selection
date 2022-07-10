import 'package:cttw_selection/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  final SettingsController settingsController;
  
  const SettingsView({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<ThemeMode>(
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('Thème système'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Thème clair'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Thème sombre'),
            ),
          ],
          onChanged: settingsController.updateThemeMode,
          value: settingsController.themeMode,
        ),
        const AboutListTile(
          icon: Icon(Icons.info_outline),
          applicationIcon: Icon(Icons.sports_tennis_outlined),
          applicationLegalese: 'Cette application est développée par Quentin Eppe.',
          applicationVersion: '1.0.0',
        ),
      ],
    );
  }
}