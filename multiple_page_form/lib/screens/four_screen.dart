import 'package:flutter/material.dart';
import 'package:multiple_page_form/app_scaffold.dart';
import 'package:multiple_page_form/app_title.dart';
import 'package:multiple_page_form/body_text.dart';
import 'package:multiple_page_form/filled_button.dart';
import 'package:multiple_page_form/onboarding_arguments.dart';

class FourScreen extends StatefulWidget {
  const FourScreen({super.key});

  @override
  _FourScreenState createState() => _FourScreenState();
}

class _FourScreenState extends State<FourScreen> {
  TextEditingController email = TextEditingController();
  bool isContinueDisabled = true;
  bool emailExistError = false;

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
            AppTitle(title: "Multi page Results"),
            BodyText(
              topMargin: 0,
              title: "Here there are the results of the form:",
              bottomMargin: 16,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Language'),
                    Text(onboardingArgs.language!),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('First Name'),
                    Text(onboardingArgs.firstName!),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Last Name'),
                    Text(onboardingArgs.lastName!),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Email'),
                    Text(onboardingArgs.email!),
                  ],
                )
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppFilledButton(
                text: "next button",
                isDisabled: false,
                onPressed: () {
                  onboardingArgs.email = email.text;
                  print('this is the end');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
