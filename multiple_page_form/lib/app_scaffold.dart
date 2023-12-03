import 'package:flutter/material.dart';

import 'package:multiple_page_form/app_bar.dart';
import 'package:multiple_page_form/app_body.dart';
import 'package:multiple_page_form/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    required this.child,
    this.appBarTitle,
    this.back,
  }) : super(key: key);
  final Widget child;
  final String? appBarTitle;
  final Function()? back;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.screenBackground,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: appBarTitle != null ? appBar(context, appBarTitle!.toUpperCase(), back) : null,
        body: AppBody(
          child: child,
        ),
      ),
    );
  }
}
