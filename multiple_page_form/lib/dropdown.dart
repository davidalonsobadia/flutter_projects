import 'package:flutter/material.dart';
import 'package:multiple_page_form/app_colors.dart';

class Dropdown extends StatelessWidget {
  final String value;
  final List items;
  final void Function(dynamic)? onChanged;
  final String? label;

  const Dropdown({Key? key, required this.value, required this.items, required this.onChanged, this.label})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            border: Border.all(color: AppColors.primary.withOpacity(0.5)),
            borderRadius:
                const BorderRadius.all(Radius.circular(8.0) //                 <--- border radius here
                    ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              SizedBox(
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: DropdownButton(
                    value: value,
                    icon: const Icon(Icons.keyboard_arrow_down_sharp),
                    iconSize: 30,
                    elevation: 16,
                    isExpanded: true,
                    style: Theme.of(context).textTheme.titleSmall,
                    onChanged: onChanged,
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    items: items.map<DropdownMenuItem>((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
