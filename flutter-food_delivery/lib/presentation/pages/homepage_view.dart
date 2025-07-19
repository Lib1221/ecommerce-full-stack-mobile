import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/controllers/product_controller.dart';
import '../../presentation/controllers/category_controller.dart';
import '../../presentation/controllers/cart_controller.dart';
import '../../presentation/controllers/theme_controller.dart';
import './modern_app_bar.dart';
import './error_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/ui_constants.dart';
import './cart_icon_with_badge.dart';

// Move ProductCard to the top-level, before HomepageView
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  const ProductCard(
      {super.key,
      required this.product,
      required this.onTap,
      required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large image area
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: product['image'] != null
                    ? Hero(
                        tag: 'product_${product['id']}',
                        child: CachedNetworkImage(
                          imageUrl: product['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: theme.dividerColor,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.broken_image,
                            size: 64,
                            color: theme.iconTheme.color?.withOpacity(0.3),
                          ),
                        ),
                      )
                    : Icon(Icons.image,
                        size: 64,
                        color: theme.iconTheme.color?.withOpacity(0.3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? '',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textTheme.bodyLarge?.color),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['price'] != null ? '\$${product['price']}' : '',
                    style: GoogleFonts.inter(
                        fontSize: 15, color: theme.textTheme.bodyMedium?.color),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: onAddToCart,
                      icon: const Icon(Icons.add_shopping_cart, size: 20),
                      label: Text('Add to Cart',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomepageView extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final CategoryController categoryController = Get.put(CategoryController());
  final CartController cartController = Get.put(CartController());
  final RxInt selectedCategoryId = 0.obs; // 0 for 'All'
  final RxInt carouselIndex = 0.obs;
  final ThemeController themeController = Get.find<ThemeController>();

  HomepageView({super.key});

  // Placeholder shimmer chips for loading state
  Widget _buildShimmerChips(ThemeData theme) {
    return Row(
      children: List.generate(
        4,
        (index) => Container(
          margin: EdgeInsets.only(right: kItemSpacing),
          width: 80,
          height: 32,
          decoration: BoxDecoration(
            color: theme.dividerColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(kCardRadius),
          ),
        ),
      ),
    );
  }

  // Placeholder shimmer grid for loading state
  Widget _buildShimmerGrid(ThemeData theme) {
    return GridView.builder(
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: kItemSpacing,
        crossAxisSpacing: kItemSpacing,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.dividerColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(kCardRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: ModernAppBar(
          title: 'Shop',
          actions: [
            CartIconWithBadge(onTap: () => Get.toNamed('/cart')),
            Obx(() {
              final isDark = themeController.isDarkMode.value;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: isDark ? 'Switch to Day Mode' : 'Switch to Night Mode',
                onPressed: () => themeController.toggleTheme(),
              );
            }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(kPagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: kItemSpacing),
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
                    separatorBuilder: (_, __) => SizedBox(width: kItemSpacing),
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
                                    borderRadius:
                                        BorderRadius.circular(kCardRadius)),
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
                                  borderRadius:
                                      BorderRadius.circular(kCardRadius)),
                            ),
                          ));
                    },
                  ),
                );
              }),
              SizedBox(height: kSectionSpacing),
              Text(
                'Featured Products',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: kItemSpacing),
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value) {
                    return _buildShimmerGrid(theme);
                  }
                  if (productController.error.isNotEmpty) {
                    return ErrorDisplay(
                      message:
                          'Failed to load products. Please check your connection and try again.',
                      onRetry: () => productController.fetchProducts(),
                    );
                  }
                  final products = productController.products;
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 100,
                              color: theme.primaryColor.withOpacity(0.15)),
                          SizedBox(height: kSectionSpacing),
                          Text('No products found',
                              style: GoogleFonts.inter(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: kItemSpacing),
                          Text('Try adjusting your search or refresh the page.',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6))),
                          SizedBox(height: kSectionSpacing),
                          ElevatedButton.icon(
                            onPressed: () => productController.fetchProducts(),
                            icon: Icon(Icons.refresh),
                            label: Text('Refresh',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(kCardRadius)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                              textStyle: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
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
                          mainAxisSpacing: kItemSpacing,
                          crossAxisSpacing: kItemSpacing,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => Get.toNamed('/product-details',
                                arguments: product),
                            onAddToCart: () {
                              cartController.addToCart(product['id']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${product['name']} added to cart!',
                                      style: GoogleFonts.inter()),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: theme.primaryColor,
                                ),
                              );
                            },
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
}
