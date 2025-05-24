// widgets/image_detail_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/features/images/data/model/image_model.dart';
import 'package:gallery_app/features/images/presentation/cubit/image_gallery_bloc.dart';
import 'package:gallery_app/features/images/presentation/cubit/image_galley_event.dart';

// widgets/image_detail_screen.dart
class ImageDetailScreen extends StatelessWidget {
  final ImageModel image;

  const ImageDetailScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(image.filename),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: 'image_${image.id}',
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: image.fullUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white, size: 64),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Image'),
          content: Text('Are you sure you want to delete "${image.filename}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Close detail screen
                context.read<ImageGalleryBloc>().add(DeleteImage(image.id));
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
