// lib/data/models/product_model.dart
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required int id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required double rating,
    required bool isOnSale,
    required int stockCount,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
          rating: rating,
          isOnSale: isOnSale,
          stockCount: stockCount,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle potential missing or invalid data in API response
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? 'No description available',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      imageUrl: json['image_url'] ?? 'https://placeholder.com/product',
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
      isOnSale: json['on_sale'] == true,
      stockCount: (json['stock_count'] is num) ? (json['stock_count'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'rating': rating,
      'on_sale': isOnSale,
      'stock_count': stockCount,
    };
  }
}
