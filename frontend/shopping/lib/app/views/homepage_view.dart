// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/product_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/cart_controller.dart';

String getFullImageUrl(String? url) {
  if (url == null) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  if (url.startsWith('/')) return 'http://localhost:8000$url';
  return url;
}

class HomepageView extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final CategoryController categoryController = Get.put(CategoryController());
  final CartController cartController = Get.put(CartController());
  final RxInt selectedCategoryId = 0.obs; // 0 for 'All'
  final RxInt carouselIndex = 0.obs;

  HomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Remove the carousel/banner Obx section and its related widgets.
              // Start the page with the Row (Shop Mobile and shopping bag icon) as the first widget in the column.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shop',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  Icon(Icons.shopping_bag,
                      size: 32, color: theme.iconTheme.color),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Categories',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (categoryController.isLoading.value) {
                  return _buildShimmerChips(theme);
                }
                if (categoryController.error.isNotEmpty) {
                  return Text('Failed to load categories',
                      style: TextStyle(color: Colors.red));
                }
                final categories = categoryController.categories;
                return SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Obx(() => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              child: ChoiceChip(
                                label: Text('All',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold)),
                                selected: selectedCategoryId.value == 0,
                                onSelected: (_) {
                                  selectedCategoryId.value = 0;
                                  productController.fetchProducts();
                                },
                                backgroundColor: theme.cardColor,
                                selectedColor:
                                    theme.primaryColor.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ));
                      }
                      final category = categories[index - 1];
                      return Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            child: ChoiceChip(
                              label: Text(category['name'] ?? '',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold)),
                              selected:
                                  selectedCategoryId.value == category['id'],
                              onSelected: (_) {
                                selectedCategoryId.value = category['id'];
                                productController.api
                                    .getProductsByCategory(category['id'])
                                    .then((products) {
                                  productController.products.value = products;
                                });
                              },
                              backgroundColor: theme.cardColor,
                              selectedColor:
                                  theme.primaryColor.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ));
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),
              Text(
                'Featured Products',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value) {
                    return _buildShimmerGrid(theme);
                  }
                  if (productController.error.isNotEmpty) {
                    return Center(
                        child: Text('Failed to load products',
                            style: TextStyle(color: Colors.red)));
                  }
                  final products = productController.products;
                  if (products.isEmpty) {
                    return Center(child: Text('No products found'));
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      if (selectedCategoryId.value == 0) {
                        await productController.fetchProducts();
                      } else {
                        final products = await productController.api
                            .getProductsByCategory(selectedCategoryId.value);
                        productController.products.value = products;
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: GridView.builder(
                        key: ValueKey(products.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutBack,
                            child: GestureDetector(
                              onTap: () => Get.toNamed('/product-details',
                                  arguments: product),
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
                                                getFullImageUrl(
                                                    product['image']),
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
                                        color:
                                            theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                    const Spacer(),
                                    AnimatedScale(
                                      scale: 1.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 40,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            cartController
                                                .addToCart(product['id']);
                                          },
                                          icon: Icon(Icons.add_shopping_cart,
                                              size: 20),
                                          label: Text('Add to Cart',
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme
                                                .elevatedButtonTheme
                                                .style
                                                ?.backgroundColor
                                                ?.resolve({}),
                                            foregroundColor: theme
                                                .elevatedButtonTheme
                                                .style
                                                ?.foregroundColor
                                                ?.resolve({}),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            elevation: 0,
                                            textStyle: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBanner(ThemeData theme) {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 18,
                    color: theme.dividerColor,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 14,
                    color: theme.dividerColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerPlaceholder(ThemeData theme) {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Center(
        child: Icon(Icons.image,
            size: 64, color: theme.iconTheme.color?.withOpacity(0.1)),
      ),
    );
  }

  Widget _buildShimmerChips(ThemeData theme) {
    return Row(
      children: List.generate(
        4,
        (i) => Container(
          width: 70,
          height: 32,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(ThemeData theme) {
    return GridView.builder(
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.dividerColor),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 16,
                width: 80,
                color: theme.dividerColor,
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 40,
                color: theme.dividerColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
