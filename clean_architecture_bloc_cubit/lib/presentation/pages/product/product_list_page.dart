// lib/presentation/pages/product/product_list_page.dart
import 'package:clean_architecture_bloc_cubit/presentation/pages/product/product_detail_page.dart';
import 'package:clean_architecture_bloc_cubit/presentation/pages/product/product_grid.dart';
import 'package:clean_architecture_bloc_cubit/presentation/widgets/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/product/product_cubit.dart';
import '../../cubits/product/product_state.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _scrollController = ScrollController();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ProductCubit>().loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductCubit>().loadMoreProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  // void _showFilterDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => ProductFilterDialog(
  //       onApplyFilters: (minPrice, maxPrice, onlyInStock, onlyOnSale) {
  //         context.read<ProductCubit>().applyFilters(
  //               minPrice: minPrice,
  //               maxPrice: maxPrice,
  //               onlyInStock: onlyInStock,
  //               onlyOnSale: onlyOnSale,
  //             );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  context.read<ProductCubit>().searchProducts(query);
                },
              )
            : Text('Products'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<ProductCubit>().loadProducts();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            //onPressed: _showFilterDialog,
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial) {
            return const LoadingIndicator();
          } else if (state is ProductLoading) {
            return const LoadingIndicator();
          } else if (state is ProductsLoaded) {
            return state.products.isEmpty
                ? Center(child: Text('No products found'))
                : ProductGrid(
                    products: state.products,
                    scrollController: _scrollController,
                    onProductTap: (product) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProductCubit>(),
                            child: ProductDetailPage(productId: product.id),
                          ),
                        ),
                      );
                    },
                    hasReachedMax: state.hasReachedMax,
                  );
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'An error occurred',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductCubit>().loadProducts();
                    },
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
