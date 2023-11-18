import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomTextStyles {
  //
  //-----------------------dipakai di booking------------------------
  static get labelHargaBooking => theme.textTheme.titleMedium!.copyWith(
        fontSize: 15,
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static get headerSubtitleBooking => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.6),
      );
  static get labelPembayaran => theme.textTheme.titleMedium!.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );
  static get titleBooking => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get subtitleBooking => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
      );
  static get labelFormBooking => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
        fontSize: 9,
      );
  static get labelJumOrang => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get labelBookingSukses => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get titleBookingSukses => theme.textTheme.displaySmall!.copyWith(
        fontSize: 34,
      );
  static get headerBooking => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get subHeaderBooking => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get teksButtonBack => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray60001,
        fontWeight: FontWeight.w600,
      );
  static get labelKeteranganTanggal =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: const Color.fromARGB(255, 122, 122, 122),
      );

  //---------------------------------dipake di register dan login----------------------
  static get titleForm => theme.textTheme.headlineLarge!.poppins.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get labelAkunRegister => theme.textTheme.bodyLarge!.poppins.copyWith(
        color: appTheme.black900,
        fontSize: 15,
      );
  static get labelRegister => theme.textTheme.bodyLarge!.poppins.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15,
      );
  static get teksTombol => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );

  static get teksHint => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray500,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  //-----------------------------dipakai di landing page-----------------
  static get labelLanding =>
      theme.textTheme.bodyMedium!.encodeSansSemiCondensed.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 11,
      );
  static get subtitleLanding =>
      theme.textTheme.displayMedium!.encodeSansSemiCondensed.copyWith(
        fontWeight: FontWeight.w700,
      );

  static get titleLanding =>
      theme.textTheme.titleLarge!.encodeSansSemiCondensed.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 19,
        fontWeight: FontWeight.w700,
      );

  //------- dipakai di appbar-----------------------

  static get teksAppbarSmall => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w600,
      );

  //------- USELESS-----------------------

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
