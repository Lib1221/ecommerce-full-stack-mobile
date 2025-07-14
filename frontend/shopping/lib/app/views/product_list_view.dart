import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/wishlist_controller.dart';

class ProductListView extends StatelessWidget {
  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();
  final wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title:
            const Text('Shop', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => productController.refreshProducts(),
          ),
          Obx(() => Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Get.toNamed('/cart'),
                  ),
                  if (cartController.items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cartController.items.length}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await productController.refreshProducts();
        },
        child: Obx(() {
          if (productController.isLoading.value &&
              productController.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productController.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 10),
                  const Text(
                    'Error loading products',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    productController.error.value,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => productController.refreshProducts(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (productController.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2, size: 60, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'No products available',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => productController.refreshProducts(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: productController.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = productController.products[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Get.toNamed('/product-details', arguments: product),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: product['image'] != null
                                      ? CachedNetworkImage(
                                          imageUrl: product['image'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey.shade200,
                                            child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2)),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey.shade100,
                                            child: const Icon(
                                                Icons.image_not_supported,
                                                size: 48,
                                                color: Colors.grey),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey.shade100,
                                          child: const Icon(
                                              Icons.image_not_supported,
                                              size: 48,
                                              color: Colors.grey),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                product['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product['price']}',
                                style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      cartController.addToCart(product['id']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text('Add to Cart',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Obx(() {
                        final isFav =
                            wishlistController.isFavorite(product['id']);
                        return InkWell(
                          onTap: () {
                            if (isFav) {
                              wishlistController
                                  .removeFromWishlist(product['id']);
                            } else {
                              wishlistController.addToWishlist(product['id']);
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
