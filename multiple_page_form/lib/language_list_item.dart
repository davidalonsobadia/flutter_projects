import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multiple_page_form/subtitle.dart';

class LanguageListItem extends StatelessWidget {
  const LanguageListItem({
    Key? key,
    required this.title,
    required this.icon,
    this.suffixIcon,
    this.onTap,
  }) : super(key: key);
  final String title;
  final String icon;
  final String? suffixIcon;

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 24,
              ),
              const SizedBox(width: 16),
              Subtitle(
                title: title,
              ),
              const Spacer(),
              if (suffixIcon != null)
                SvgPicture.asset(
                  suffixIcon!,
                  height: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
