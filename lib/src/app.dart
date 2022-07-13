import 'package:cttw_selection/src/page_manager.dart';
import 'package:cttw_selection/src/settings/app_theme.dart' as app_theme;
import 'package:cttw_selection/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CTTWSelectionApp extends StatelessWidget {
  final SettingsController settingsController;

  const CTTWSelectionApp({
    super.key,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    // Utilisation de [AnimatedBuilder] afin de
    // mettre à jour l'interface quand le thème change
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        return MaterialApp(
          title: 'CTTW Sélection', // Le titre de l'application
          home: PageManager(
            settingsController: settingsController,
          ),
          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale('fr'), // Français, pas de pays
          ],
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate, // les widgets généraux
            GlobalMaterialLocalizations.delegate, // les widgets Material Design
            GlobalCupertinoLocalizations.delegate, // les widgets Cupertino (Apple design)
          ],
          theme: app_theme.lightTheme, // Le thème clair
          darkTheme: app_theme.darkTheme, // Le thème sombre
          themeMode: settingsController.themeMode, // Le thème sélectionné
        );
      },
    );
  }
}