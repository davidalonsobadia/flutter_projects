// lib/data/local/product_local_datasource.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getLastProducts();
  Future<Product> getProductById(int id);
  Future<void> cacheProducts(List<Product> products);
  Future<void> cacheProduct(Product product);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  static const String CACHED_PRODUCTS_KEY = 'CACHED_PRODUCTS';
  static const String CACHED_PRODUCT_PREFIX = 'CACHED_PRODUCT_';

  @override
  Future<List<Product>> getLastProducts() async {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS_KEY);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      return decodedJson.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('No cached products found');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    final jsonString = sharedPreferences.getString('$CACHED_PRODUCT_PREFIX$id');
    if (jsonString != null) {
      return ProductModel.fromJson(json.decode(jsonString));
    } else {
      throw Exception('No cached product found with id: $id');
    }
  }

  @override
  Future<void> cacheProducts(List<Product> products) async {
    final List<Map<String, dynamic>> jsonList =
        products.map((product) => (product as ProductModel).toJson()).toList();

    await sharedPreferences.setString(CACHED_PRODUCTS_KEY, json.encode(jsonList));
  }

  @override
  Future<void> cacheProduct(Product product) async {
    await sharedPreferences.setString(
        '$CACHED_PRODUCT_PREFIX${product.id}', json.encode((product as ProductModel).toJson()));
  }
}
