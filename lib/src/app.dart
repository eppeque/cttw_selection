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
    return AnimatedBuilder(
      animation: settingsController,
      builder: (context, _) {
        return MaterialApp(
          title: 'CTTW Sélection',
          home: PageManager(
            settingsController: settingsController,
          ),
          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale('fr'), // French, no country code
          ],
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: app_theme.lightTheme,
          darkTheme: app_theme.darkTheme,
          themeMode: settingsController.themeMode,
        );
      },
    );
  }
}