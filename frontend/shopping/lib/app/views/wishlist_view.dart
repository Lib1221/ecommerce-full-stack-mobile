import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/wishlist_controller.dart';
import '../controllers/product_controller.dart';

String getFullImageUrl(String? url) {
  if (url == null) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  if (url.startsWith('/')) return 'http://localhost:8000$url';
  return url;
}

class WishlistView extends StatelessWidget {
  final WishlistController wishlistController = Get.find<WishlistController>();
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'Wishlist',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() {
            final favIds = wishlistController.favorites.toList();
            final products = productController.products
                .where((p) => favIds.contains(p['id']))
                .toList();
            if (products.isEmpty) {
              return Center(
                child: Text('Your wishlist is empty',
                    style: GoogleFonts.inter(fontSize: 18)),
              );
            }
            return ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final product = products[index];
                final isFav = wishlistController.isFavorite(product['id']);
                return GestureDetector(
                  onTap: () =>
                      Get.toNamed('/product-details', arguments: product),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        product['image'] != null
                            ? Hero(
                                tag: 'product_${product['id']}',
                                child: Image.network(
                                    getFullImageUrl(product['image']),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.contain))
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
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
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
