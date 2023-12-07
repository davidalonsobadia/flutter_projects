import 'package:flutter/material.dart';
import 'package:multiple_page_form/screens/first_screen.dart';
import 'package:multiple_page_form/route/app_router.dart';
import 'package:multiple_page_form/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: const FirstScreen(),
      onGenerateRoute: AppRouter().onGenerateRoute,
    );
  }
}
