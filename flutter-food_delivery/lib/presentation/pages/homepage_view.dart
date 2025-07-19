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
                                  borderRadius:
                                      BorderRadius.circular(kCardRadius),
                                  border: Border.all(color: theme.dividerColor),
                                ),
                                padding: const EdgeInsets.all(kCardPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: product['image'] != null
                                          ? Hero(
                                              tag: 'product_${product['id']}',
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl: product['image'],
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    color: theme.dividerColor,
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: theme.iconTheme.color
                                                        ?.withOpacity(0.3),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Icon(Icons.image,
                                              size: 40,
                                              color: theme.iconTheme.color
                                                  ?.withOpacity(0.3)),
                                    ),
                                    SizedBox(height: kItemSpacing),
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
                                    SizedBox(height: kItemSpacing),
                                    Text(
                                      product['price'] != null
                                          ? '\$${product['price']}'
                                          : '',
                                      style: GoogleFonts.inter(
                                        color:
                                            theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                    SizedBox(height: kItemSpacing),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        cartController.addToCart(product['id']);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${product['name']} added to cart!',
                                              style: GoogleFonts.inter(),
                                            ),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: theme.primaryColor,
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.add_shopping_cart),
                                      label: Text('Add to Cart',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.primaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        textStyle: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
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
}
