import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/controllers/product_controller.dart';
import './error_display.dart';
import 'homepage_view.dart'; // Import ProductCard
import '../../presentation/controllers/cart_controller.dart'; // Import CartController

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  final TextEditingController searchController = TextEditingController();
  RxList products = [].obs;
  RxBool isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    products.value = productController.products;
    ever(productController.products, (_) {
      if (!isSearching.value) {
        products.value = productController.products;
      }
    });
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      products.value = productController.products;
      isSearching.value = false;
      return;
    }
    isSearching.value = true;
    final lower = query.toLowerCase();
    products.value = productController.products.where((p) {
      final name = (p['name'] ?? '').toString().toLowerCase();
      final desc = (p['description'] ?? '').toString().toLowerCase();
      return name.contains(lower) || desc.contains(lower);
    }).toList();
  }

  String getFullImageUrl(String? url) {
    if (url == null) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('/')) return 'http://localhost:8000$url';
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                controller: searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (productController.error.isNotEmpty) {
                  return ErrorDisplay(
                    message:
                        'Failed to load products. Please check your connection and try again.',
                    onRetry: () => productController.fetchProducts(),
                  );
                }
                if (products.isEmpty) {
                  return Center(
                      child: Text('No products found',
                          style: GoogleFonts.inter()));
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () =>
                          Get.toNamed('/product-details', arguments: product),
                      onAddToCart: () {
                        cartController.addToCart(product['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product['name']} added to cart!',
                                style: GoogleFonts.inter()),
                            duration: const Duration(seconds: 1),
                            backgroundColor: theme.primaryColor,
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
