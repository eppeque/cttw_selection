import 'package:flutter/material.dart';

const appColor = Color(0xFF007B83);

final lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: appColor,
  fontFamily: 'Zen Kaku Gothic Antique',
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: appColor,
  fontFamily: 'Zen Kaku Gothic Antique',
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);