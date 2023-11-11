import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeDeeppurple500 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.deepPurple500,
      );
  static get bodyLargePoppinsBlack900 =>
      theme.textTheme.bodyLarge!.poppins.copyWith(
        color: appTheme.black900,
      );
  static get bodyLargePoppinsBlack90017 =>
      theme.textTheme.bodyLarge!.poppins.copyWith(
        color: appTheme.black900,
        fontSize: 15,
      );
  static get bodyLargePoppinsPrimary =>
      theme.textTheme.bodyLarge!.poppins.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15,
      );
  static get bodyMediumEncodeSansSemiCondensedOnPrimary =>
      theme.textTheme.bodyMedium!.encodeSansSemiCondensed.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 11,
      );
  static get bodyMediumLight => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w300,
      );
  static get bodyMediumOnPrimary => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get bodySmall10 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 8,
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.6),
      );
  static get bodySmallBlack90010 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
        fontSize: 8,
      );
  static get bodySmallBlack900_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.6),
      );
  static get bodySmallBlack900_2 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
      );
  static get bodySmallInterCyan700 => theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.cyan700,
      );
  static get bodySmallInterGray700 => theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.gray700,
        fontSize: 8,
      );
  static get bodySmallInterGray70011 =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.gray700,
        fontSize: 9,
      );
  static get bodySmallInterOnPrimary =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 7,
      );
  static get bodySmallInterOnPrimaryContainer =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );
  static get bodySmallInterOnPrimaryContainer10 =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 8,
      );
  static get bodySmallInterOnPrimaryContainer_1 =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );
  static get bodySmallLight => theme.textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w300,
      );
  static get bodySmallPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodySmall_1 => theme.textTheme.bodySmall!;
  // Display text style
  static get displayMediumEncodeSansSemiCondensed =>
      theme.textTheme.displayMedium!.encodeSansSemiCondensed.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get displaySmall36 => theme.textTheme.displaySmall!.copyWith(
        fontSize: 34,
      );
  static get displaySmallGray800 => theme.textTheme.displaySmall!.copyWith(
        color: appTheme.gray800,
        fontSize: 36,
      );
  // Headline text style
  static get headlineLargePoppinsBlack900 =>
      theme.textTheme.headlineLarge!.poppins.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  // Label text style
  static get labelLargeBlack900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBlack900Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBlack900Medium_1 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGreenA700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.greenA700,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterOnPrimaryContainer =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );
  static get labelLargeSecondaryContainer =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.secondaryContainer,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );
  static get labelMediumOnPrimary => theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 9,
        fontWeight: FontWeight.w600,
      );
  static get labelMediumOnPrimarySemiBold =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get labelMediumOnPrimarySemiBold11 =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 9,
        fontWeight: FontWeight.w600,
      );
  static get labelMediumOnPrimarySemiBold_1 =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get labelMediumSemiBold => theme.textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get labelSmallOnPrimary => theme.textTheme.labelSmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static get labelSmallOnPrimary_1 => theme.textTheme.labelSmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static get labelSmallOnPrimary_2 => theme.textTheme.labelSmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  // Poppins text style
  static get poppinsOnPrimary => TextStyle(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 5,
        fontWeight: FontWeight.w500,
      ).poppins;
  // Title text style
  static get titleLargeBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleLargeEncodeSansSemiCondensedOnPrimary =>
      theme.textTheme.titleLarge!.encodeSansSemiCondensed.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 19,
        fontWeight: FontWeight.w700,
      );
  static get titleLargeOnPrimary => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static get titleMedium17 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 15,
      );
  static get titleMediumGray500 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray500,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumGray600 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray600,
        fontSize: 15,
      );
  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPrimarySemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumSemiBold => theme.textTheme.titleMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumSemiBold14 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumSemiBold14_1 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumSemiBold_1 => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleSmallBlack900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallBlack900SemiBold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallGray60001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray60001,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallGray900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallRoboto => theme.textTheme.titleSmall!.roboto;
  static get titleSmallRobotoDeeppurple500 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: appTheme.deepPurple500,
      );
  static get titleSmallRobotoErrorContainer =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get titleSmallSemiBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      );
}

extension on TextStyle {
  TextStyle get anton {
    return copyWith(
      fontFamily: 'Anton',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get encodeSansSemiCondensed {
    return copyWith(
      fontFamily: 'Encode Sans Semi Condensed',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }
}
