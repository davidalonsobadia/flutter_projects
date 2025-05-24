// lib/domain/repositories/product_repository.dart
import 'package:clean_architecture_bloc_cubit/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getFeaturedProducts();
  Future<Product> getProductById(int id);
  Future<List<Product>> searchProducts(String query);
}
