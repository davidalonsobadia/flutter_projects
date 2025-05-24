import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/features/images/presentation/cubit/image_gallery_bloc.dart';
import 'package:gallery_app/features/images/presentation/pages/image_gallery_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageGalleryBloc(),
      child: MaterialApp(
        title: 'Image Gallery',
        theme: ThemeData(primarySwatch: Colors.blue, visualDensity: VisualDensity.adaptivePlatformDensity),
        home: ImageGalleryScreen(),
      ),
    );
  }
}
