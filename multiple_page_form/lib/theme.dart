import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

final ThemeData theme = _buildTheme();

class AppColors {
  static const Color primary = Color(0xFF374957);
  static const Color error = Color(0xFFD2492B);
}

ThemeData _buildTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    appBarTheme: const AppBarTheme(elevation: 0, systemOverlayStyle: SystemUiOverlayStyle.dark),
    primaryColor: AppColors.primary,
    //     colorScheme: ColorScheme( //TODO: we should need to apply some colorScheme
    //   brightness: brightness,
    //   primary: primary,
    //   onPrimary: onPrimary,
    //   secondary: secondary,
    //   onSecondary: onSecondary,
    //   error: error,
    //   onError: onError,
    //   background: background,
    //   onBackground: onBackground,
    //   surface: surface,
    //   onSurface: onSurface,
    // ),
    errorColor: AppColors.error,
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    pageTransitionsTheme: base.pageTransitionsTheme,
  );
}

// InputDecorationTheme inputDecorationTheme() {
//   OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.circular(4),
//   );
//   return InputDecorationTheme(
//     contentPadding: const EdgeInsets.all(10),
//     enabledBorder: outlineInputBorder,
//     focusedBorder: outlineInputBorder,
//     border: InputBorder.none,
//     floatingLabelAlignment: FloatingLabelAlignment.start,
//     floatingLabelBehavior: FloatingLabelBehavior.auto,
//     isCollapsed: true,
//     filled: true,
//     fillColor: Colors.white.withOpacity(0.64),
//   );
// }

TextTheme _buildTextTheme(TextTheme base) {
  return GoogleFonts.poppinsTextTheme(base
      .copyWith(
        displayLarge: base.displayLarge!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 93,
          letterSpacing: -1.5,
        ),
        displayMedium: base.displayMedium!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 58,
          letterSpacing: -0.5,
        ),
        displaySmall: base.displaySmall!.copyWith(
          fontSize: 46,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: base.headlineMedium!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 36,
          letterSpacing: 0.25,
        ),
        headlineSmall: base.headlineSmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        titleLarge: base.titleLarge!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 19,
          letterSpacing: 0.15,
        ),
        titleMedium: base.titleMedium!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        titleSmall: base.titleSmall!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: base.bodyLarge!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
        bodyMedium: base.bodyMedium!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          letterSpacing: 0.4,
        ),
        bodySmall: base.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          letterSpacing: 0.4,
        ),
        labelLarge: base.labelLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          letterSpacing: 0.15,
        ),
        labelSmall: base.labelSmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          letterSpacing: 0.4,
        ),
      )
      .apply(
        displayColor: AppColors.primary,
        bodyColor: AppColors.primary,
      ));
}
