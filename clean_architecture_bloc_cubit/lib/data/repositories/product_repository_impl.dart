// lib/data/repositories/product_repository_impl.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../providers/api_client.dart';
import '../local/product_local_datasource.dart';
import '../../core/network/network_info.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.apiClient,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        // Get products from API
        final jsonList = await apiClient.getProducts();
        final products = jsonList.map((json) => ProductModel.fromJson(json)).toList();

        // Cache products locally
        await localDataSource.cacheProducts(products);
        return products;
      } catch (e) {
        // If API fails, try to get cached products
        print('API error: $e - Attempting to retrieve from cache');
        return await localDataSource.getLastProducts();
      }
    } else {
      print('No internet connection - Retrieving from cache');
      // No internet, get cached products
      return await localDataSource.getLastProducts();
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        // Get product from API
        final json = await apiClient.getProductById(id);
        final product = ProductModel.fromJson(json);

        // Cache product locally
        await localDataSource.cacheProduct(product);
        return product;
      } catch (e) {
        // If API fails, try to get cached product
        print('API error: $e - Attempting to retrieve from cache');
        return await localDataSource.getProductById(id);
      }
    } else {
      // No internet, get cached product
      return await localDataSource.getProductById(id);
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    final products = await getProducts();
    // Apply domain business logic filter
    return products.where((product) => product.isFeatured).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final jsonList = await apiClient.searchProducts(query);
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } catch (e) {
        // If API search fails, do local search
        print('Search API error: $e - Attempting local search');
        final products = await localDataSource.getLastProducts();
        return _localSearch(products, query);
      }
    } else {
      // No internet, do local search
      final products = await localDataSource.getLastProducts();
      return _localSearch(products, query);
    }
  }

  // Helper method for local search
  List<Product> _localSearch(List<Product> products, String query) {
    final lowercaseQuery = query.toLowerCase();
    return products
        .where((product) =>
            product.name.toLowerCase().contains(lowercaseQuery) ||
            product.description.toLowerCase().contains(lowercaseQuery))
        .toList();
  }
}
