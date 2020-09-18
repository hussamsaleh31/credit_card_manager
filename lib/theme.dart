import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6990AF);
const Color secondaryColor = Color(0xFF73AFB0);

final ThemeData lightTheme = _buildLightTheme();
final ThemeData darkTheme = _buildDarkTheme();
ThemeData _buildLightTheme() {
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData(
    brightness: Brightness.light,
    accentColorBrightness: Brightness.dark,
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    toggleableActiveColor: secondaryColor,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    accentColor: secondaryColor,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      brightness: Brightness.light,
      elevation: 1,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.blue,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
      elevation: 1,
    ),
    iconTheme: IconThemeData(
      color: Colors.blue,
    ),
  );
  return base;
}

ThemeData _buildDarkTheme() {
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData(
    brightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    primaryColor: primaryColor,
    cardColor: Color(0xFF121A26),
    primaryColorDark: const Color(0xFF0050a0),
    primaryColorLight: secondaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    toggleableActiveColor: secondaryColor,
    accentColor: secondaryColor,
    canvasColor: const Color(0xFF2A4058),
    scaffoldBackgroundColor: const Color(0xFF121A26),
    backgroundColor: const Color(0xFF0D1520),
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(),
    iconTheme: IconThemeData(
      color: const Color(0xFF2A4058),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF2A4058),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.white,
      ),
      selectedItemColor: Colors.blue,
      elevation: 1,
    ),
  );
  return base;
}
