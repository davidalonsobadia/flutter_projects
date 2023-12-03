import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  const BodyText({
    Key? key,
    required this.title,
    this.bottomMargin,
    this.topMargin,
  }) : super(key: key);
  final String title;
  final double? bottomMargin;
  final double? topMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topMargin ?? 8.0, bottom: bottomMargin ?? 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
