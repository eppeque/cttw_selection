import 'package:flutter/material.dart';

/// La couleur de l'application
const appColor = Color(0xFF007B83);

/// Le thème clair
final lightTheme = ThemeData(
  useMaterial3: true, // L'app utilise le Material Design 3
  colorSchemeSeed: appColor,
  fontFamily: 'Zen Kaku Gothic Antique',
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

/// Le thème sombre
final darkTheme = ThemeData(
  useMaterial3: true, // L'app utilise le Material Design 3
  colorSchemeSeed: appColor,
  fontFamily: 'Zen Kaku Gothic Antique',
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);