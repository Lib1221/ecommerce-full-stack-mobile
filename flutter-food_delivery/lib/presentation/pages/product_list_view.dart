import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/controllers/product_controller.dart';
import './modern_app_bar.dart';
import './error_display.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ProductController productController = Get.find<ProductController>();
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
        appBar: ModernAppBar(
          title: 'Products',
          actions: [
            IconButton(
              icon: Icon(Icons.grid_view),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
                style:
                    GoogleFonts.inter(color: theme.textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 24),
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
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/product-details', arguments: product);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              product['image'] != null
                                  ? Hero(
                                      tag: 'product_${product['id']}',
                                      child: Image.network(
                                          getFullImageUrl(product['image']),
                                          height: 60,
                                          fit: BoxFit.contain))
                                  : Icon(Icons.image,
                                      size: 48,
                                      color: theme.iconTheme.color
                                          ?.withOpacity(0.3)),
                              const SizedBox(height: 12),
                              Text(
                                product['name'] ?? '',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product['price'] != null
                                    ? '\$${product['price']}'
                                    : '',
                                style: GoogleFonts.inter(
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
