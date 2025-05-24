// lib/presentation/cubits/product/product_state.dart
import '../../../../../../domain/entities/product.dart';

abstract class ProductState {
  // Adding common properties
  final bool isLoading;
  final String? errorMessage;

  ProductState({
    this.isLoading = false,
    this.errorMessage,
  });
}

class ProductInitial extends ProductState {
  ProductInitial() : super(isLoading: false);
}

class ProductLoading extends ProductState {
  ProductLoading() : super(isLoading: true);
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;

  ProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
  }) : super(isLoading: false);

  // Immutability helper - create new instance with updated data
  ProductsLoaded copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? hasReachedMax,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ProductDetailLoaded extends ProductState {
  final Product product;

  ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductError extends ProductState {
  ProductError(String message) : super(isLoading: false, errorMessage: message);
}
