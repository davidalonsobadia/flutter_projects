import 'package:flutter/material.dart';
import 'package:multiple_page_form/app_scaffold.dart';
import 'package:multiple_page_form/app_title.dart';
import 'package:multiple_page_form/dropdown.dart';
import 'package:multiple_page_form/filled_button.dart';
import 'package:multiple_page_form/form_input.dart';
import 'package:multiple_page_form/onboarding_arguments.dart';
import 'package:multiple_page_form/route/app_route.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  bool continueDisabled = true;
  List title = ["Mr", "Mrs", "Ms", "Miss", "Dr", "Prof"];
  String selectedTitle = "Mr";
  enableContinue() {
    if (lastName.text.isNotEmpty && firstName.text.isNotEmpty) {
      continueDisabled = false;
    } else {
      continueDisabled = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final onboardingArgs = ModalRoute.of(context)!.settings.arguments as OnboardingArgument;
    return AppScaffold(
      appBarTitle: "back",
      child: CustomScrollView(
          //Instead of ListView or SingleChildScrollView put CustomScrollVIew to use Expanded or spacer
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTitle(title: "Title"),
                    Dropdown(
                      items: title,
                      onChanged: (value) {
                        setState(() {
                          selectedTitle = value;
                        });
                      },
                      value: selectedTitle,
                      label: "title",
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      textCapitalization: TextCapitalization.words,
                      label: "first name",
                      placeholder: "first name placeholder",
                      controller: firstName,
                      onChanged: (text) {
                        enableContinue();
                      },
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      textCapitalization: TextCapitalization.words,
                      label: "last name",
                      placeholder: "last name placeholder",
                      controller: lastName,
                      onChanged: (text) {
                        enableContinue();
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: AppFilledButton(
                        text: "Next",
                        isDisabled: continueDisabled,
                        onPressed: () {
                          onboardingArgs.firstName = firstName.text;
                          onboardingArgs.lastName = lastName.text;
                          onboardingArgs.title = selectedTitle;
                          Navigator.pushNamed(
                            context,
                            AppRoute.thirdScreen,
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
            ),
          ]),
    );
  }
}
