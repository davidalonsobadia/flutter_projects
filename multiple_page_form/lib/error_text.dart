import 'package:flutter/material.dart';

import 'package:multiple_page_form/app_colors.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    Key? key,
    this.color,
    required this.title,
  }) : super(key: key);
  final Color? color;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: color ?? AppColors.error),
        ),
      ],
    );
  }
}
