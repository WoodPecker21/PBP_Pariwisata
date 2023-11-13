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

  static get bodySmallInterOnPrimary =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 7,
      );

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
  static get titleMediumSemiBold16 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPrimarySemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static get bodySmallBlack900_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.6),
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
        color: const Color.fromARGB(255, 122, 122, 122),
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
