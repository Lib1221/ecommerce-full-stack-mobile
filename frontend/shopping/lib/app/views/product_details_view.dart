import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

class ProductDetailsView extends StatelessWidget {
  final Map product;
  final cartController = Get.find<CartController>();
  final wishlistController = Get.find<WishlistController>();

  ProductDetailsView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: product['image'] != null
                  ? CachedNetworkImage(
                      imageUrl: product['image'],
                      height: 220,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 220,
                        color: Colors.grey.shade200,
                        child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 220,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_not_supported,
                            size: 60, color: Colors.grey),
                      ),
                    )
                  : Container(
                      height: 220,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image_not_supported,
                          size: 60, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              product['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product['price']}',
              style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              product['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => cartController.addToCart(product['id']),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Obx(() {
                  final isFav = wishlistController.isFavorite(product['id']);
                  return SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (isFav) {
                          wishlistController.removeFromWishlist(product['id']);
                        } else {
                          wishlistController.addToWishlist(product['id']);
                        }
                      },
                      icon:
                          Icon(isFav ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFav ? 'Remove' : 'Wishlist'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isFav ? Colors.red : Colors.deepPurple.shade100,
                        foregroundColor:
                            isFav ? Colors.white : Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
