import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multiple_page_form/theme.dart';

class ButtonOutline extends StatelessWidget {
  const ButtonOutline({
    Key? key,
    this.color,
    required this.text,
    required this.onPressed,
    this.width,
  }) : super(key: key);

  final Color? color;
  final String text;
  final VoidCallback onPressed;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kIsWeb ? 56 : null,
      width: width ?? double.maxFinite,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(width: 1.0, color: color ?? AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 16)),
        onPressed: onPressed,
        child: Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: color ?? AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
