import 'package:flutter/material.dart';
import 'package:cttw_selection/src/settings/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Effectue la communication entre l'app et les [SharedPreferences].
/// Les [SharedPreferences] sont des données simples mémorisées nativement
/// par la plateforme sur laquelle l'app est exécutée.
/// Par exemple, dans notre cas, nous utilisons les [SharedPreferences] pour
/// mémoriser le thème sélectionné par l'utilisateur.
/// Ce thème sera mémorisé sous forme d'entier :
/// - 0 -> Thème système -> [ThemeMode.system]
/// - 1 -> Thème clair -> [ThemeMode.light]
/// - 2 -> Thème sombre -> [ThemeMode.dark]
/// Chaque entier correspond donc à un thème représenté
/// en Flutter par une énumération [ThemeMode]
/// 
/// Cette classe est uniquement utilisée par [SettingsController]
class SettingsService {
  /// Récupère et donne le thème enregistré dans la mémoire.
  /// Si aucun thème n'a été précédemment enregistré, le thème système est retourné [Theme]
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeCode = prefs.getInt('themeCode') ?? 0;

    if (themeCode == 0) return ThemeMode.system;

    if (themeCode == 1) return ThemeMode.light;

    return ThemeMode.dark;
  }

  /// Met à jour le thème sélectionné en mémoire
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    late int themeCode;

    switch (themeMode) {
      case ThemeMode.system:
        themeCode = 0;
        break;
      case ThemeMode.light:
        themeCode = 1;
        break;
      case ThemeMode.dark:
        themeCode = 2;
        break;
    }

    prefs.setInt('themeCode', themeCode);
  }
}