import 'package:flutter/material.dart';
import 'package:multiple_page_form/size_config.dart';

class AppBody extends StatelessWidget {
  const AppBody({
    Key? key,
    required this.child,
    this.maxWidth = AppBreakpoints.small,
    this.topMargin,
    this.bottomMargin,
  }) : super(key: key);
  final Widget child;
  final double maxWidth;
  final bool? topMargin;
  final double? bottomMargin;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: topMargin ?? true,
        maintainBottomViewPadding: true,
        minimum: const EdgeInsets.only(bottom: 0),
        child: Center(
          child: SizedBox(
            width: screenWidth > maxWidth ? maxWidth : screenWidth,
            child: child,
          ),
        ),
      ),
    );
  }
}
