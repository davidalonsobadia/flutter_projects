import 'package:flutter/material.dart';
import 'package:multiple_page_form/size_config.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    Key? key,
    required this.title,
    this.isPadding = true,
    this.bottomPadding,
    this.paddingTop,
  }) : super(key: key);
  final String title;
  final bool isPadding;
  final double? bottomPadding;
  final double? paddingTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isPadding ? 24 : 0, bottom: bottomPadding ?? 40, top: paddingTop ?? 0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
