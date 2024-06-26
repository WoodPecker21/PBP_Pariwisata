import 'dart:ui';
import 'package:flutter/material.dart';

String _appTheme = "primary";

/// Helper class for managing themes and colors.
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    // throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedCustomColor.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found. Make sure you have added this theme class in JSON. Try running flutter pub run build_runner");
    }
    // return theme from map
    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    // throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedColorScheme.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found. Make sure you have added this theme class in JSON. Try running flutter pub run build_runner");
    }
    // return theme from map
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.onPrimary.withOpacity(1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.gray20001,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return appTheme.gray900;
          }
          return colorScheme.onSurface;
        }),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.black900.withOpacity(0.1),
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.gray90001,
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: colorScheme.onPrimary.withOpacity(1),
          fontSize: 42,
          fontFamily: 'Anton',
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: colorScheme.onPrimary.withOpacity(1),
          fontSize: 37,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: appTheme.gray90001,
          fontSize: 32,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onPrimary.withOpacity(1),
          fontSize: 13,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 10,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 8,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: colorScheme.onPrimary.withOpacity(1),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    // Primary colors
    primary: Color(0XFF0044AA),
    primaryContainer: Color(0XFFD0D0D0),
    secondaryContainer: Color(0X7F0044AA),

    // Error colors
    errorContainer: Color(0XFF49454F),

    // On colors(text colors)
    onPrimary: Color(0XCCFFFFFF),
    onPrimaryContainer: Color(0XFF1E1E1E),
  );
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // Amber
  Color get amberA200 => Color(0XFFFFCD3C);

  // Black
  Color get black900 => Color(0XFF000000);

  // Blue
  Color get blue500 => Color(0XFF2395FD);
  Color get blueA700 => Color(0XFF0066FF);

  // BlueGray
  Color get blueGray100 => Color(0XFFCAC4D0);
  Color get blueGray10001 => Color(0XFFD9D9D9);

  // Cyan
  Color get cyan700 => Color(0XFF008FA0);

  // DeepPurple
  Color get deepPurple50 => Color(0XFFECE6F0);
  Color get deepPurple500 => Color(0XFF6750A4);

  // Gray
  Color get gray100 => Color(0XFFF7F7F7);
  Color get gray10001 => Color(0XFFF2F2F2);
  Color get gray200 => Color(0XFFEBEBEB);
  Color get gray20001 => Color(0XFFE8E8E8);
  Color get gray300 => Color(0XFFE4E4E4);
  Color get gray400 => Color(0XFFAFAFAF);
  Color get gray500 => Color(0XFF9D9D9D);
  Color get gray600 => Color(0XFF777474);
  Color get gray60001 => Color(0XFF797979);
  Color get gray60033 => Color(0X338F7F7F);
  Color get gray700 => Color(0XFF636363);
  Color get gray800 => Color(0XFF4D3C3C);
  Color get gray900 => Color(0XFF191919);
  Color get gray90001 => Color(0XFF1D1B20);

  // Green
  Color get greenA700 => Color(0XFF00A638);

  // Indigo
  Color get indigo200 => Color(0XFF9CBAE6);
  Color get indigo20001 => Color(0XFF8CA3E7);

  // Orange
  Color get orange300 => Color(0XFFFAB057);

  // Yellow
  Color get yellowA700 => Color(0XFFE1D800);
}

PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
