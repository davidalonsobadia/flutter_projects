import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_and_geo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  runApp(
    CameraAndGeo(cameras: cameras),
  );
}
