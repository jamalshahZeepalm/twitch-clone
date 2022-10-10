import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    
    scaffoldBackgroundColor: CustomColors.backgroundColor,
    drawerTheme: DrawerThemeData(
      backgroundColor: CustomColors.backgroundColor,
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.transparent),
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: CustomColors.kPrimaryColor,
    drawerTheme: DrawerThemeData(
      backgroundColor: CustomColors.kPrimaryColor,
    ),
    colorScheme: const ColorScheme.dark(),
  );
}
