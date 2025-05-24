import 'package:gallery_app/features/images/data/model/image_model.dart';

abstract class ImageGalleryState {}

class ImageGalleryInitial extends ImageGalleryState {}

class ImageGalleryLoading extends ImageGalleryState {}

class ImageGalleryLoaded extends ImageGalleryState {
  final List<ImageModel> images;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingMore;
  final DateTime lastRefreshTime;
  final int totalCount;

  ImageGalleryLoaded({
    required this.images,
    required this.currentPage,
    required this.hasNextPage,
    this.isLoadingMore = false,
    required this.lastRefreshTime,
    required this.totalCount,
  });

  ImageGalleryLoaded copyWith({
    List<ImageModel>? images,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingMore,
    DateTime? lastRefreshTime,
    int? totalCount,
  }) {
    return ImageGalleryLoaded(
      images: images ?? this.images,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      lastRefreshTime: lastRefreshTime ?? this.lastRefreshTime,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class ImageGalleryError extends ImageGalleryState {
  final String message;
  ImageGalleryError(this.message);
}

class ImageUploading extends ImageGalleryState {
  final List<ImageModel> images;
  final double progress;

  ImageUploading({required this.images, required this.progress});
}
