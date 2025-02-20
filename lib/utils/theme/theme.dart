import 'package:flutter/material.dart';
import 'package:recloth_x/utils/theme/widgetThemes/appbar_theme.dart';
import 'package:recloth_x/utils/theme/widgetThemes/bottom_sheet_theme.dart';
import 'package:recloth_x/utils/theme/widgetThemes/checkbox_theme.dart';
import 'package:recloth_x/utils/theme/widgetThemes/chip_theme.dart';
import 'package:recloth_x/utils/theme/widgetThemes/elevated_button_theme.dart';
import 'package:recloth_x/utils/theme/widgetThemes/outlined_button_theme.dart';
import 'package:recloth_x/utils/theme/widgetThemes/text_field_theme.dart';
import 'package:recloth_x/utils/theme/widgetThemes/text_theme.dart';

import '../constants/colors.dart';

class RAppTheme {
  RAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: RColors.grey,
    brightness: Brightness.light,
    primaryColor: RColors.primary,
    textTheme: RTextTheme.lightTextTheme,
    chipTheme: RChipTheme.lightChipTheme,
    scaffoldBackgroundColor: RColors.white,
    appBarTheme: RAppBarTheme.lightAppBarTheme,
    checkboxTheme: RCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: RBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: RElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: ROutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: RTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: RColors.grey,
    brightness: Brightness.dark,
    primaryColor: RColors.primary,
    textTheme: RTextTheme.darkTextTheme,
    chipTheme: RChipTheme.darkChipTheme,
    scaffoldBackgroundColor: RColors.black,
    appBarTheme: RAppBarTheme.darkAppBarTheme,
    checkboxTheme: RCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: RBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: RElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: ROutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: RTextFormFieldTheme.darkInputDecorationTheme,
  );
}
