import 'package:flutter/material.dart';
import 'package:multiple_page_form/app_scaffold.dart';
import 'package:multiple_page_form/app_title.dart';
import 'package:multiple_page_form/constants/app_images.dart';
import 'package:multiple_page_form/language_list_item.dart';
import 'package:multiple_page_form/onboarding_arguments.dart';
import 'package:multiple_page_form/route/app_route.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: "Back",
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitle(title: 'Choose Language'),
            LanguageListItem(
              title: "English",
              icon: AppImages.ukIcon,
              onTap: () {
                //changeLocale(context, Language.english);
                //Utils.setAppLanguage(Language.english);
                Navigator.pushNamed(context, AppRoute.secondScreen,
                    arguments: OnboardingArgument(language: Language.english));
              },
            ),
            LanguageListItem(
              title: "German",
              icon: AppImages.germanIcon,
              onTap: () {
                // changeLocale(context, Language.german);
                //Utils.setAppLanguage(Language.german);
                Navigator.pushNamed(context, AppRoute.secondScreen,
                    arguments: OnboardingArgument(language: Language.german));
              },
            ),
          ],
        ),
      ),
    );
  }
}
