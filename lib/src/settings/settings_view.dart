import 'package:cttw_selection/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// L'interface des paramètres de l'application
class SettingsView extends StatelessWidget {
  final SettingsController settingsController;
  
  const SettingsView({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Le bouton de sélection de thème
        DropdownButton<ThemeMode>(
          items: const [
            // Thème système
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('Thème système'),
            ),

            // Thème clair
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Thème clair'),
            ),

            // Thème sombre
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Thème sombre'),
            ),
          ],
          // Demande au gestionnaire des paramètres
          // de mettre à jour le thème sélectionné
          onChanged: settingsController.updateThemeMode,

          // Le thème actuellement sélectionné
          value: settingsController.themeMode,
        ),

        // Bouton permattant d'afficher les licenses et
        // les mentions légales de l'application
        const AboutListTile(
          icon: Icon(Icons.info_outline),
          applicationIcon: Icon(FontAwesomeIcons.tableTennisPaddleBall),
          applicationLegalese: 'Cette application est développée par Quentin Eppe.',
          applicationVersion: '1.0.0',
        ),
      ],
    );
  }
}