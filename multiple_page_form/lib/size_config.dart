import 'package:flutter/material.dart';

extension MediaQueryDataProportionate on MediaQueryData {
  /// 812 is the layout height that designer use
  static const double layoutHeight = 812.0;

  /// 375 is the layout width that designer use
  static const double layoutWidth = 315.0;

  /// Get the proportionate height as per screen size.
  double getProportionateScreenHeight(double inputHeight) => (inputHeight / layoutHeight) * size.height;

  /// Get the proportionate height as per screen size.
  double getProportionateScreenWidth(double inputWidth) => (inputWidth / layoutWidth) * size.width;
}

class AppBreakpoints {
  /// Breakpoints - max width
  static const double small = 500.0;
  static const double medium = 1092.0;
  static const double large = 1228.0;
}

class AppSizes {
  // Wide screen content maxWidth
  static const double wideContentMaxWidth = 900.0;

  // Navigation Rail
  static const double railMinWidth = 80.0;
  static const double railMinWidthExtended = 216.0;

  // Dialogs
  static const double dialogWidth = 400.0;

  // Toasts and snackbars
  static const double toastWidth = 468.0;
}
