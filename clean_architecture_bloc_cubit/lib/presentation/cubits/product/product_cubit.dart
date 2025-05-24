// lib/presentation/cubits/product/product_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../domain/usecases/get_products.dart';
//import '../../../domain/usecases/get_product_details.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProducts;
  //final GetProductDetails getProductDetails;

  // Add debouncer for search functionality
  Timer? _debounce;

  ProductCubit({
    required this.getProducts,
    //required this.getProductDetails,
  }) : super(ProductInitial());

  Future<void> loadProducts() async {
    // Don't show loading if we already have products (for pagination)
    final currentState = state;
    if (currentState is ProductsLoaded) {
      emit(ProductsLoaded(
        products: currentState.products,
        hasReachedMax: currentState.hasReachedMax,
      ).copyWith(isLoading: true));
    } else {
      emit(ProductLoading());
    }

    try {
      final products = await getProducts();
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // Pagination support
  Future<void> loadMoreProducts() async {
    final currentState = state;

    if (currentState is ProductsLoaded && !currentState.isLoading && !currentState.hasReachedMax) {
      try {
        // In a real app, would pass the next page parameter to the API
        final moreProducts = await getProducts();

        if (moreProducts.isEmpty) {
          // No more products to load
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          // Combine existing and new products
          emit(ProductsLoaded(
            products: [...currentState.products, ...moreProducts],
            hasReachedMax: false,
          ));
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> loadProductDetails(int productId) async {
    emit(ProductLoading());
    try {
      //final product = await getProductDetails(productId);
      //emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // Apply filters to products
  Future<void> applyFilters({
    double? minPrice,
    double? maxPrice,
    bool? onlyInStock,
    bool? onlyOnSale,
  }) async {
    emit(ProductLoading());
    try {
      final filteredProducts = await getProducts.withFilters(
        minPrice: minPrice,
        maxPrice: maxPrice,
        onlyInStock: onlyInStock,
        onlyOnSale: onlyOnSale,
      );
      emit(ProductsLoaded(products: filteredProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // Search with debouncing
  void searchProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        // If empty query, load all products
        loadProducts();
        return;
      }

      emit(ProductLoading());
      try {
        // In a real app, would call a search repository method
        final filteredProducts = await getProducts.withFilters();
        final searchResults = filteredProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()))
            .toList();

        emit(ProductsLoaded(products: searchResults));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
