import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/wishlist_controller.dart';
import '../../presentation/controllers/product_controller.dart';
import 'modern_app_bar.dart';
import 'error_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/ui_constants.dart';
import 'cart_icon_with_badge.dart';
import '../../presentation/controllers/theme_controller.dart';

class WishlistView extends StatelessWidget {
  final WishlistController wishlistController = Get.find<WishlistController>();
  final ProductController productController = Get.find<ProductController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: ModernAppBar(
          title: 'Wishlist',
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
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(kPagePadding),
          child: Obx(() {
            if (productController.error.isNotEmpty) {
              return ErrorDisplay(
                message:
                    'Failed to load wishlist products. Please check your connection and try again.',
                onRetry: () => productController.fetchProducts(),
              );
            }
            final favIds = wishlistController.favorites.toList();
            final products = productController.products
                .where((p) => favIds.contains(p['id']))
                .toList();
            if (products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 100, color: theme.primaryColor.withOpacity(0.15)),
                    SizedBox(height: kSectionSpacing),
                    Text('Your wishlist is empty',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: kItemSpacing),
                    Text('Save products you love for later.',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              );
            }
            return ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: kItemSpacing),
              itemBuilder: (context, index) {
                final product = products[index];
                final isFav = wishlistController.isFavorite(product['id']);
                return GestureDetector(
                  onTap: () =>
                      Get.toNamed('/product-details', arguments: product),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(kCardRadius),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    padding: const EdgeInsets.all(kCardPadding),
                    child: Row(
                      children: [
                        product['image'] != null
                            ? Hero(
                                tag: 'product_${product['id']}',
                                child: CachedNetworkImage(
                                  imageUrl: product['image'],
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: theme.dividerColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: theme.iconTheme.color
                                          ?.withOpacity(0.3)),
                                ),
                              )
                            : Icon(Icons.image,
                                size: 40,
                                color: theme.iconTheme.color?.withOpacity(0.3)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? '',
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['price'] != null
                                    ? '\$${product['price']}'
                                    : '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav
                              ? theme.primaryColor
                              : theme.iconTheme.color,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
