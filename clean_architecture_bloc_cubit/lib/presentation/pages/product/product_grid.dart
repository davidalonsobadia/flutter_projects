// lib/presentation/widgets/product/product_grid.dart
import 'package:clean_architecture_bloc_cubit/presentation/pages/product/product_card.dart';
import 'package:flutter/material.dart';
import '../../../../../../domain/entities/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final ScrollController scrollController;
  final Function(Product) onProductTap;
  final bool hasReachedMax;

  const ProductGrid({
    Key? key,
    required this.products,
    required this.scrollController,
    required this.onProductTap,
    this.hasReachedMax = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: hasReachedMax ? products.length : products.length + 1,
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        return GestureDetector(
          onTap: () => onProductTap(products[index]),
          child: ProductCard(product: products[index]),
        );
      },
    );
  }
}
