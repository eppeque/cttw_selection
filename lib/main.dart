import 'package:cttw_selection/src/app.dart';
import 'package:cttw_selection/src/settings/settings_controller.dart';
import 'package:cttw_selection/src/settings/settings_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());
  await settingsController.initSettings();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(CTTWSelectionApp(settingsController: settingsController));
}