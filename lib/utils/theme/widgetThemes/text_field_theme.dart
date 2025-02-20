import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class RTextFormFieldTheme {
  RTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: RColors.darkGrey,
    suffixIconColor: RColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: RSizes.fontSizeMd, color: RColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: RSizes.fontSizeSm, color: RColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: RColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.grey),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: RColors.red),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: RColors.darkGrey,
    suffixIconColor: RColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: RSizes.fontSizeMd, color: RColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: RSizes.fontSizeSm, color: RColors.white),
    floatingLabelStyle: const TextStyle().copyWith(color: RColors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: RColors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(RSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: RColors.red),
    ),
  );
}
