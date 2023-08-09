import 'package:camera/camera.dart';
import 'package:camera_and_geo_app/home_screen.dart';
import 'package:flutter/material.dart';

import 'camera_screen.dart';
import 'geo_screen.dart';

class CameraAndGeo extends StatefulWidget {
  const CameraAndGeo({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<CameraAndGeo> createState() {
    return _CameraAndGeo();
  }
}

class _CameraAndGeo extends State<CameraAndGeo> {
  String activeScreen = 'home-screen';
  Widget? screenWidget;

  @override
  void initState() {
    super.initState();
    screenWidget = HomeScreen(
      goToCamera: goToCamera,
      goToGeo: goToGeo,
    );
  }

  void goToCamera() {
    setState(() {
      activeScreen = 'camera-screen';
    });
  }

  void goToGeo() {
    setState(() {
      activeScreen = 'geo-screen';
    });
  }

  void goToHomeScreen() {
    setState(() {
      activeScreen = 'home-screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (activeScreen == 'camera-screen') {
      screenWidget = CameraScreen(
        cameras: widget.cameras,
        goToHomeScreen: goToHomeScreen,
      );
    } else if (activeScreen == 'geo-screen') {
      screenWidget = GeoScreen(goToHomeScreen: goToHomeScreen);
    } else if (activeScreen == 'home-screen') {
      screenWidget = screenWidget = HomeScreen(
        goToCamera: goToCamera,
        goToGeo: goToGeo,
      );
    }

    return MaterialApp(title: 'Camera and Geo App', home: screenWidget);
  }
}
