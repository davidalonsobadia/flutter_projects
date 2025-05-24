// widgets/image_gallery_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery_app/features/images/data/model/image_model.dart';
import 'package:gallery_app/features/images/presentation/cubit/image_gallery_bloc.dart';
import 'package:gallery_app/features/images/presentation/cubit/image_gallery_state.dart';
import 'package:gallery_app/features/images/presentation/cubit/image_galley_event.dart';
import 'package:gallery_app/features/images/presentation/pages/image_detail_screen.dart';
import 'package:gallery_app/shared/screens/camera_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageGalleryScreen extends StatefulWidget {
  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ImageGalleryBloc>().add(LoadImages());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ImageGalleryBloc>().add(LoadNextPage());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        context.read<ImageGalleryBloc>().add(AddImage(imageFile));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _takePhotoAndUpload() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        final File photoFile = File(photo.path);
        context.read<ImageGalleryBloc>().add(AddImage(photoFile));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to take photo: $e')));
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              SizedBox(height: 20),
              Text('Add New Image', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _openCameraScreen();
                    },
                  ),
                  _buildImageSourceOption(
                    icon: Icons.photo_camera,
                    label: 'Quick Photo',
                    onTap: () {
                      Navigator.pop(context);
                      _takePhotoAndUpload();
                    },
                  ),
                  _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickAndUploadImage();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _openCameraScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 2),
            ),
            child: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showDeleteDialog(String imageId, String filename) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Image'),
          content: Text('Are you sure you want to delete "$filename"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ImageGalleryBloc>().add(DeleteImage(imageId));
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<ImageGalleryBloc>().add(RefreshGallery()),
          ),
        ],
      ),
      body: BlocConsumer<ImageGalleryBloc, ImageGalleryState>(
        listener: (context, state) {
          if (state is ImageGalleryError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is ImageGalleryLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ImageUploading) {
            return Column(
              children: [
                LinearProgressIndicator(value: state.progress),
                SizedBox(height: 8),
                Text('Uploading... ${(state.progress * 100).toInt()}%'),
                SizedBox(height: 16),
                Expanded(child: _buildImageGrid(state.images, isUploading: true)),
              ],
            );
          }

          if (state is ImageGalleryLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ImageGalleryBloc>().add(RefreshGallery());
              },
              child: Column(
                children: [
                  if (state.isLoadingMore) LinearProgressIndicator(),
                  Expanded(child: _buildImageGrid(state.images)),
                ],
              ),
            );
          }

          if (state is ImageGalleryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ImageGalleryBloc>().add(LoadImages()),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageSourceBottomSheet,
        child: Icon(Icons.add_a_photo),
        tooltip: 'Add Image',
      ),
    );
  }

  Widget _buildImageGrid(List<ImageModel> images, {bool isUploading = false}) {
    if (images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No images yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 8),
            Text('Tap the + button to add your first image'),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return _buildImageTile(image, isUploading);
      },
    );
  }

  Widget _buildImageTile(ImageModel image, bool isUploading) {
    return GestureDetector(
      onTap: () => _showImageDetail(image),
      onLongPress: isUploading ? null : () => _showDeleteDialog(image.id, image.filename),
      child: Hero(
        tag: 'image_${image.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: image.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: Colors.grey[300],
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                  errorWidget:
                      (context, url, error) =>
                          Container(color: Colors.grey[300], child: Icon(Icons.error, color: Colors.red)),
                ),
                if (isUploading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      image.filename,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageDetail(ImageModel image) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetailScreen(image: image)));
  }
}
