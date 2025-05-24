import 'dart:io';

abstract class ImageGalleryEvent {}

class LoadImages extends ImageGalleryEvent {
  final bool isRefresh;
  LoadImages({this.isRefresh = false});
}

class LoadNextPage extends ImageGalleryEvent {}

class AddImage extends ImageGalleryEvent {
  final File imageFile;
  AddImage(this.imageFile);
}

class DeleteImage extends ImageGalleryEvent {
  final String imageId;
  DeleteImage(this.imageId);
}

class RefreshGallery extends ImageGalleryEvent {}
