import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_app/features/images/data/data_sources/api_service.dart';
import 'package:gallery_app/features/images/data/model/image_model.dart';
import 'package:gallery_app/features/images/presentation/cubit/image_gallery_state.dart';

import 'package:gallery_app/features/images/presentation/cubit/image_galley_event.dart';

class ImageGalleryBloc extends Bloc<ImageGalleryEvent, ImageGalleryState> {
  static const int _pageSize = 20;
  static const Duration _cacheValidityDuration = Duration(minutes: 5);

  ImageGalleryBloc() : super(ImageGalleryInitial()) {
    on<LoadImages>(_onLoadImages);
    on<LoadNextPage>(_onLoadNextPage);
    on<AddImage>(_onAddImage);
    on<DeleteImage>(_onDeleteImage);
    on<RefreshGallery>(_onRefreshGallery);
  }

  Future<void> _onLoadImages(LoadImages event, Emitter<ImageGalleryState> emit) async {
    try {
      // If not refresh and we have cached data that's still valid, return early
      if (!event.isRefresh && state is ImageGalleryLoaded) {
        final loadedState = state as ImageGalleryLoaded;
        final timeSinceRefresh = DateTime.now().difference(loadedState.lastRefreshTime);
        if (timeSinceRefresh < _cacheValidityDuration) {
          return;
        }
      }

      emit(ImageGalleryLoading());

      final response = await ApiService.getImages(page: 1, limit: _pageSize);

      emit(
        ImageGalleryLoaded(
          images: response.items,
          currentPage: response.currentPage,
          hasNextPage: response.hasNext,
          lastRefreshTime: DateTime.now(),
          totalCount: response.totalCount,
        ),
      );
    } catch (e) {
      emit(ImageGalleryError(e.toString()));
    }
  }

  Future<void> _onLoadNextPage(LoadNextPage event, Emitter<ImageGalleryState> emit) async {
    if (state is! ImageGalleryLoaded) return;

    final currentState = state as ImageGalleryLoaded;
    if (!currentState.hasNextPage || currentState.isLoadingMore) return;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final response = await ApiService.getImages(page: currentState.currentPage + 1, limit: _pageSize);

      final updatedImages = List<ImageModel>.from(currentState.images)..addAll(response.items);

      emit(
        ImageGalleryLoaded(
          images: updatedImages,
          currentPage: response.currentPage,
          hasNextPage: response.hasNext,
          lastRefreshTime: currentState.lastRefreshTime,
          totalCount: response.totalCount,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
      // You might want to show a snackbar or toast here
    }
  }

  Future<void> _onAddImage(AddImage event, Emitter<ImageGalleryState> emit) async {
    if (state is! ImageGalleryLoaded) return;

    final currentState = state as ImageGalleryLoaded;

    try {
      emit(ImageUploading(images: currentState.images, progress: 0.0));

      await Future.delayed(Duration(seconds: 2));

      // Simulate upload progress (you can make this more sophisticated)
      emit(ImageUploading(images: currentState.images, progress: 0.5));

      await Future.delayed(Duration(seconds: 3));

      final newImage = await ApiService.uploadImage(event.imageFile);

      emit(ImageUploading(images: currentState.images, progress: 1.0));

      // Add new image to the beginning of the list
      final updatedImages = [newImage, ...currentState.images];

      emit(
        ImageGalleryLoaded(
          images: updatedImages,
          currentPage: currentState.currentPage,
          hasNextPage: currentState.hasNextPage,
          lastRefreshTime: DateTime.now(),
          totalCount: currentState.totalCount + 1,
        ),
      );
    } catch (e) {
      emit(ImageGalleryError('Failed to upload image: $e'));
      // Restore previous state after showing error
      Future.delayed(Duration(seconds: 2), () {
        if (state is ImageGalleryError) {
          emit(currentState);
        }
      });
    }
  }

  Future<void> _onDeleteImage(DeleteImage event, Emitter<ImageGalleryState> emit) async {
    if (state is! ImageGalleryLoaded) return;

    final currentState = state as ImageGalleryLoaded;
    final imageToDelete = currentState.images.firstWhere((img) => img.id == event.imageId);

    // Optimistic update - remove immediately
    final updatedImages = currentState.images.where((img) => img.id != event.imageId).toList();

    emit(currentState.copyWith(images: updatedImages, totalCount: currentState.totalCount - 1));

    try {
      await ApiService.deleteImage(event.imageId);
      // Success - the optimistic update stays
    } catch (e) {
      // Failure - restore the image
      final restoredImages = List<ImageModel>.from(updatedImages);
      final originalIndex = currentState.images.indexOf(imageToDelete);
      restoredImages.insert(originalIndex, imageToDelete);

      emit(
        currentState.copyWith(
          images: restoredImages,
          totalCount: currentState.totalCount, // Restore original count
        ),
      );

      // Show error (you might want to use a different mechanism)
      emit(ImageGalleryError('Failed to delete image: $e'));
      Future.delayed(Duration(seconds: 2), () {
        if (state is ImageGalleryError) {
          emit(currentState.copyWith(images: restoredImages));
        }
      });
    }
  }

  Future<void> _onRefreshGallery(RefreshGallery event, Emitter<ImageGalleryState> emit) async {
    add(LoadImages(isRefresh: true));
  }
}
