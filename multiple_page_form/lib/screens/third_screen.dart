import 'package:flutter/material.dart';
import 'package:multiple_page_form/app_scaffold.dart';
import 'package:multiple_page_form/app_title.dart';
import 'package:multiple_page_form/body_text.dart';
import 'package:multiple_page_form/filled_button.dart';
import 'package:multiple_page_form/form_input.dart';
import 'package:multiple_page_form/onboarding_arguments.dart';
import 'package:multiple_page_form/route/app_route.dart';
import 'package:multiple_page_form/utils.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  TextEditingController email = TextEditingController();
  bool isContinueDisabled = true;
  bool emailExistError = false;

  @override
  Widget build(BuildContext context) {
    final signUpScreenArgs = ModalRoute.of(context)!.settings.arguments as OnboardingArgument;
    return AppScaffold(
      appBarTitle: "back",
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitle(title: "Email title"),
            BodyText(
              topMargin: 0,
              title: "here we should add a short description about to add an email",
              bottomMargin: 16,
            ),
            FormInput(
              label: "email label",
              placeholder: "email label placeholder",
              controller: email,
              onChanged: (email) {
                emailExistError = false;
                if (Utils.isValidEmail(email)) {
                  setState(() {
                    isContinueDisabled = false;
                  });
                } else {
                  setState(() {
                    isContinueDisabled = true;
                  });
                }
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppFilledButton(
                text: "next button",
                isDisabled: isContinueDisabled,
                onPressed: () {
                  signUpScreenArgs.email = email.text;
                  Navigator.pushNamed(
                    context,
                    AppRoute.fourScreen,
                    arguments: signUpScreenArgs,
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
