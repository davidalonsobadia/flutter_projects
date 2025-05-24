// lib/domain/entities/product.dart
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final bool isOnSale;
  final int stockCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.isOnSale,
    required this.stockCount,
  });

  bool get isInStock => stockCount > 0;

  // Domain business logic for determining if a product is featured
  bool get isFeatured => rating >= 4.5 && isOnSale;

  // Domain logic for calculating discount price
  double getDiscountPrice(double discountPercentage) {
    return price * (1 - discountPercentage / 100);
  }
}
