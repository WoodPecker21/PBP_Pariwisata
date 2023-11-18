import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillDeepPurple => BoxDecoration(
        color: appTheme.deepPurple50,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray200,
      );
  static BoxDecoration get fillGray100 => BoxDecoration(
        color: appTheme.gray100,
      );
  static BoxDecoration get fillGray300 => BoxDecoration(
        color: appTheme.gray300,
      );
  static BoxDecoration get fillGray60033 => BoxDecoration(
        color: appTheme.gray60033,
      );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.primaryContainer,
      );

  // Gradient decorations
  static BoxDecoration get gradientPrimaryToIndigo => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            theme.colorScheme.primary,
            appTheme.indigo200,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(
              0,
              -2,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
        border: Border.all(
          color: appTheme.black900,
          width: 1,
        ),
      );
  static BoxDecoration get outlineBlack9001 => BoxDecoration(
        border: Border.all(
          color: appTheme.black900.withOpacity(0.15),
          width: 1,
        ),
      );
  static BoxDecoration get outlineBlueGray => BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appTheme.blueGray100,
            width: 1,
          ),
        ),
      );
  static BoxDecoration get outlineDeepPurple => BoxDecoration(
        border: Border.all(
          color: appTheme.deepPurple500,
          width: 1,
        ),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: appTheme.yellowA700,
        border: Border.all(
          color: appTheme.gray400,
          width: 1,
        ),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder20 => BorderRadius.circular(
        20,
      );

  // Custom borders
  static BorderRadius get customBorderBL64 => BorderRadius.only(
        topLeft: Radius.circular(11),
        topRight: Radius.circular(11),
        bottomLeft: Radius.circular(64),
        bottomRight: Radius.circular(64),
      );
  static BorderRadius get customBorderTL27 => BorderRadius.vertical(
        top: Radius.circular(27),
      );

  // Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10,
      );
  static BorderRadius get roundedBorder15 => BorderRadius.circular(
        15,
      );
  static BorderRadius get roundedBorder24 => BorderRadius.circular(
        24,
      );
  static BorderRadius get roundedBorder28 => BorderRadius.circular(
        28,
      );
  static BorderRadius get roundedBorder35 => BorderRadius.circular(
        35,
      );
  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;
