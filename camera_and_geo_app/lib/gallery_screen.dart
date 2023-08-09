import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_and_geo.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({
    Key? key,
    required this.images,
    required this.cameras,
  }) : super(key: key);
  final List<File> images;
  final List<CameraDescription> cameras;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: images
                  .map((image) => Image.file(image, fit: BoxFit.cover))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 50,
            ),
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraAndGeo(cameras: cameras)));
              },
              child: const Text('Back'),
            ),
          )
        ],
      ),
    );
  }
}
