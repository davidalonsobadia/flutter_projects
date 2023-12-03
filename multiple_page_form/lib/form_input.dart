import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiple_page_form/app_colors.dart';

class FormInput extends StatefulWidget {
  const FormInput({
    Key? key,
    this.label,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onEditingComplete,
    this.obsecureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.isError = false,
    this.width,
    this.textInputType,
    this.backgroundColor,
    this.borderColor,
    this.autofillHints,
    this.enabled,
    this.autofocus = false,
  }) : super(key: key);
  final label;
  final controller;
  final placeholder;
  final prefixIcon;
  final Widget? suffixIcon;
  final bool isError;
  final bool obsecureText;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final double? width;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool? autofillHints;
  final bool? enabled;
  final bool autofocus;

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  FocusNode focus = FocusNode();
  bool isFocused = false;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    focus.addListener(onFocusChange);
  }

  void onFocusChange() {
    isFocused = focus.hasFocus;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String _getRegexString() => r'[0-9]+[,.]{0,1}[0-9]*';

    TextTheme textTheme = Theme.of(context).textTheme;
    return MouseRegion(
      onEnter: (event) {
        isHovered = true;
        setState(() {});
      },
      onExit: (event) {
        isHovered = false;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppColors.inputBackground,
          border: Border.all(
            width: isFocused || isHovered ? 2 : 1,
            color: widget.isError
                ? Colors.red
                : isFocused
                    ? AppColors.primary
                    : isHovered
                        ? AppColors.primary.withOpacity(0.5)
                        : widget.borderColor ?? AppColors.primary.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0) //                 <--- border radius here
              ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: TextField(
                autofocus: widget.autofocus,
                enabled: widget.enabled,
                scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 200,
                ),
                textCapitalization: widget.textCapitalization,
                enableSuggestions: true,
                autofillHints: widget.autofillHints != null ? const <String>[AutofillHints.oneTimeCode] : [],
                controller: widget.controller,
                inputFormatters: widget.inputFormatters,
                keyboardType: widget.textInputType ?? TextInputType.emailAddress,
                onChanged: widget.onChanged,
                focusNode: focus,

                onEditingComplete: widget.onEditingComplete,
                keyboardAppearance:
                    Brightness.light, // no matter what you set, it simply shows white keyboard

                style: textTheme.subtitle1,
                obscureText: widget.obsecureText,
                decoration: InputDecoration(
                  prefixIcon: widget.prefixIcon,
                  border: InputBorder.none,
                  hintText: widget.placeholder,
                  labelText: widget.label,
                  labelStyle: TextStyle(
                    color: widget.isError
                        ? Colors.red
                        : isFocused
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle:
                      TextStyle(color: AppColors.primary.withOpacity(0.5), fontWeight: FontWeight.w400),
                ),
              ),
            ),
            if (widget.suffixIcon != null) widget.suffixIcon!,
          ],
        ),
      ),
    );
  }
}
