import 'package:flutter/material.dart';
import 'package:multiple_page_form/screens/first_screen.dart';
import 'package:multiple_page_form/route/app_route.dart';
import 'package:multiple_page_form/screens/four_screen.dart';
import 'package:multiple_page_form/screens/second_screen.dart';
import 'package:multiple_page_form/screens/third_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.secondScreen:
        return MaterialPageRoute(
          builder: (_) => const SecondScreen(),
          settings: RouteSettings(
            arguments: settings.arguments,
          ),
        );
      case AppRoute.thirdScreen:
        return MaterialPageRoute(
          builder: (_) => const ThirdScreen(),
          settings: RouteSettings(
            arguments: settings.arguments,
          ),
        );
      case AppRoute.fourScreen:
        return MaterialPageRoute(
          builder: (_) => FourScreen(),
          settings: RouteSettings(
            arguments: settings.arguments,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const FirstScreen(),
        );
    }
  }
}
