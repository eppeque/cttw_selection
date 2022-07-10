import 'package:cttw_selection/src/app.dart';
import 'package:cttw_selection/src/settings/settings_controller.dart';
import 'package:cttw_selection/src/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

// Le point d'entrée de l'application
void main() async {
  // Evite l'erreur lorsque des tâches asynchrones sont executées dans le main()
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation des paramètres de l'app
  final settingsController = SettingsController(SettingsService());
  await settingsController.initSettings();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Exécution de l'application (UI)
  runApp(CTTWSelectionApp(settingsController: settingsController));
}