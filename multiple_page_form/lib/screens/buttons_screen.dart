import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:multiple_page_form/app_scaffold.dart';
import 'package:multiple_page_form/app_text.button.dart';
import 'package:multiple_page_form/app_title.dart';
import 'package:multiple_page_form/filled_button.dart';
import 'package:multiple_page_form/onboarding_arguments.dart';
import 'package:multiple_page_form/route/app_route.dart';
import 'package:multiple_page_form/select_button.dart';
import 'package:multiple_page_form/select_country_button.dart';
import 'package:multiple_page_form/subtitle.dart';

class FourScreen extends StatefulWidget {
  const FourScreen({super.key});

  @override
  _FourScreenState createState() => _FourScreenState();
}

class _FourScreenState extends State<FourScreen> {
  bool isContinueDisabled = true;
  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    final onboardingArgs = ModalRoute.of(context)!.settings.arguments as OnboardingArgument;

    return AppScaffold(
      appBarTitle: "back",
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTitle(title: "Select Country"),
            ElevatedButton(
              onPressed: () {
                showCountryPicker(
                  context: context,
                  onSelect: (Country country) {
                    setState(() {
                      isContinueDisabled = false;
                    });
                    selectedCountry = country.displayName;
                  },
                );
              },
              child: const Text('Show country picker'),
            ),
            const SizedBox(
              height: 10,
            ),
            SelectButton(title: 'Show country picker', isSelected: false),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(onPressed: () {}, child: Text('This is an outlinedButton')),
            const SizedBox(
              height: 10,
            ),
            AppTextButton(
              label: 'label of app text button',
              onTap: () {},
            ),
            const SizedBox(
              height: 10,
            ),
            SelectCountryButton(
              text: 'Select Country',
              onPressed: () {
                showCountryPicker(
                  context: context,
                  onSelect: (Country country) {
                    setState(() {
                      isContinueDisabled = false;
                    });
                    selectedCountry = country.name;
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            selectedCountry != null
                ? Subtitle(title: 'Country Selected: $selectedCountry')
                : const SizedBox(
                    height: 10,
                  ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppFilledButton(
                text: "next button",
                isDisabled: isContinueDisabled,
                onPressed: () {
                  onboardingArgs.country = selectedCountry;
                  Navigator.pushNamed(
                    context,
                    AppRoute.lastScreen,
                    arguments: onboardingArgs,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
