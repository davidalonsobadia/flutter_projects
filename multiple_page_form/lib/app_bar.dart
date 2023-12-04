import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multiple_page_form/app_colors.dart';
import 'package:multiple_page_form/constants/app_images.dart';

AppBar appBar(context, title, Function()? back) {
  return AppBar(
    backgroundColor: AppColors.screenBackground,
    titleSpacing: 0.0,
    centerTitle: false,
    systemOverlayStyle: const SystemUiOverlayStyle(
      // systemNavigationBarColor: AppColors.screenBackground, // Navigation bar
      statusBarColor: AppColors.screenBackground, // Status bar
      // FOR iOS Only - This sets status bar text color https://www.flutterbeads.com/change-status-bar-color-in-flutter/
      statusBarBrightness: Brightness.light,
    ),
    toolbarHeight: 40,
    leadingWidth: 56,
    leading: IconButton(
      icon: SvgPicture.asset(AppImages.arrowBack),
      onPressed: back ??
          () {
            Navigator.of(context).pop();
          },
    ),
  );
}
