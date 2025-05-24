// lib/domain/usecases/get_products.dart
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  // Basic use case to get all products
  Future<List<Product>> call() async {
    return await repository.getProducts();
  }

  // Additional method to get products with filtering
  Future<List<Product>> withFilters({
    double? minPrice,
    double? maxPrice,
    bool? onlyInStock,
    bool? onlyOnSale,
  }) async {
    List<Product> allProducts = await repository.getProducts();

    return allProducts.where((product) {
      // Apply price filter
      if (minPrice != null && product.price < minPrice) return false;
      if (maxPrice != null && product.price > maxPrice) return false;

      // Apply stock filter
      if (onlyInStock == true && !product.isInStock) return false;

      // Apply sale filter
      if (onlyOnSale == true && !product.isOnSale) return false;

      return true;
    }).toList();
  }
}
