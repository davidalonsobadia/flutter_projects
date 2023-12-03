import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({
    Key? key,
    required this.title,
    this.margin,
    this.bottomMargin,
  }) : super(key: key);
  final String title;
  final double? margin;
  final double? bottomMargin;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(top: margin ?? 0, bottom: bottomMargin ?? 0),
      child: Text(
        title,
        style: textTheme.subtitle2!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
