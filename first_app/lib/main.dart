import 'package:flutter/material.dart';

import 'package:first_app/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GradientContainer(
          colors: [
            Color.fromARGB(255, 75, 21, 169),
            Color.fromARGB(255, 99, 63, 162),
          ],
        ),
      ),
    ),
  );
}
