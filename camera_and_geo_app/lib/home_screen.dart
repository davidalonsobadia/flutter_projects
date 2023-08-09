import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.goToCamera,
    required this.goToGeo,
  });

  final void Function() goToCamera;
  final void Function() goToGeo;

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  void goToCamera() {
    widget.goToCamera();
  }

  void goToGeo() {
    widget.goToGeo();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FilledButton.tonal(
                onPressed: goToCamera,
                child: const Text('Go to Camera'),
              ),
              const SizedBox(
                height: 30,
              ),
              FilledButton(
                onPressed: goToGeo,
                child: const Text('Go to Geo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
