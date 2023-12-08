import 'package:flutter/material.dart';
import 'package:multiple_page_form/theme.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
          child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: AppColors.placeholder, fontWeight: FontWeight.w600),
      )),
    );
  }
}
