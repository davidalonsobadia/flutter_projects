import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multiple_page_form/app_colors.dart';

class SelectCountryButton extends StatelessWidget {
  const SelectCountryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.upcomingIcon,
    this.isLoading = false,
    this.textColor = Colors.white,
    this.width,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final Color backgroundColor;
  final bool isLoading;
  final Color textColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: kIsWeb ? 56 : null,
      width: width ?? double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isLoading ? AppColors.buttonPressed : backgroundColor,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: !isLoading
            ? Text(
                text.toUpperCase(),
                style: textTheme.labelLarge?.copyWith(color: textColor),
              )
            : const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
      ),
    );
  }
}
