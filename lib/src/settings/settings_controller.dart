import 'package:cttw_selection/src/settings/settings_service.dart';
import 'package:flutter/material.dart';

/// Gère les paramètres de l'application.
/// Permet de récupérer le thème actuellement sélectionné
/// et modifier dynamiquement ce thème.
/// 
/// Cette classe utilise [SettingsService] pour
/// communiquer avec la mémoire de la platforme exécutant l'application
/// et [ChangeNotifier] pour mettre à jour l'entierté de l'interface
/// quand le thème sélectionné est mis à jour
class SettingsController with ChangeNotifier {
  /// Les services permettant la communcation avec la mémoire de la plateforme
  final SettingsService _settingsService;

  /// Crée le gestionnaire des paramètres de l'application. Cette classe devrait être instanciée comme suit :
  /// 
  /// ```dart
  /// final settingsController = SettingsController(SettingsService());
  /// await settingsController.initSettings();
  /// ```
  /// 
  /// La méthode [initSettings] permet de placer le gestionnaire
  /// dans un état cohérent.
  SettingsController(this._settingsService);

  /// Le thème actuellement sélectionné utilisé par cette classe
  late ThemeMode _themeMode;

  /// Le thème actuellement sélectionné accessible en dehors de cette classe
  ThemeMode get themeMode => _themeMode;

  /// Initialise les paramètres de l'application.
  /// Cette méthode devrait être appelée dès l'instanciation du gestionnaire
  /// afin de le placer dans un état cohérent.
  Future<void> initSettings() async {
    _themeMode = await _settingsService.themeMode();
    notifyListeners();
  }

  /// Met à jour le thème sélectionné et demande à l'interface de se rafraîchir
  Future<void> updateThemeMode(ThemeMode? themeMode) async {
    if (themeMode == null) return;

    if (themeMode == _themeMode) return;

    _themeMode = themeMode;
    notifyListeners();

    await _settingsService.updateThemeMode(themeMode);
  }
}