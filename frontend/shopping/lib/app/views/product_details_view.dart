import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../services/api_service.dart';
import '../../theme.dart';

class ProductDetailsView extends StatefulWidget {
  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final CartController cartController = Get.find<CartController>();
  final ApiService api = ApiService();
  final WishlistController wishlistController = Get.find<WishlistController>();
  Map<String, dynamic>? product;
  List<dynamic> relatedProducts = [];
  bool isLoadingRelated = true;

  @override
  void initState() {
    super.initState();
    product = Get.arguments;
    _fetchRelated();
  }

  Future<void> _fetchRelated() async {
    if (product != null && product!['category'] != null) {
      try {
        final catId = product!['category'];
        final rel = await api.getProductsByCategory(catId);
        // Remove the current product from related
        relatedProducts = rel.where((p) => p['id'] != product!['id']).toList();
      } catch (e) {
        relatedProducts = [];
      }
    }
    setState(() {
      isLoadingRelated = false;
    });
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
    if (product == null) {
      return Scaffold(
        body: Center(
            child: Text('Product not found', style: GoogleFonts.inter())),
      );
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: theme.iconTheme,
          title: Text(
            'Product Details',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              Hero(
                tag: 'product_${product!['id']}',
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: product!['image'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                              getFullImageUrl(product!['image']),
                              fit: BoxFit.contain),
                        )
                      : Icon(Icons.image,
                          size: 80,
                          color: theme.iconTheme.color?.withOpacity(0.2)),
                ),
              ),
              const SizedBox(height: 28),
              // Product Name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product!['name'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  Obx(() {
                    final isFav = wishlistController.isFavorite(product!['id']);
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : theme.iconTheme.color,
                        size: 32,
                      ),
                      onPressed: () {
                        if (isFav) {
                          wishlistController.removeFromWishlist(product!['id']);
                        } else {
                          wishlistController.addToWishlist(product!['id']);
                        }
                        setState(() {});
                      },
                      tooltip:
                          isFav ? 'Remove from Wishlist' : 'Add to Wishlist',
                    );
                  }),
                ],
              ),
              const SizedBox(height: 10),
              // Price
              Text(
                product!['price'] != null ? '\$${product!['price']}' : '',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 18),
              // Description
              if (product!['description'] != null &&
                  product!['description'].toString().isNotEmpty)
                Text(
                  product!['description'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              if (product!['description'] == null ||
                  product!['description'].toString().isEmpty)
                Text(
                  'No description available.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              const SizedBox(height: 28),
              // Add to Cart Button
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    cartController.addToCart(product!['id']);
                  },
                  icon: Icon(Icons.add_shopping_cart, size: 22),
                  label: Text('Add to Cart',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme
                        .elevatedButtonTheme.style?.backgroundColor
                        ?.resolve({}),
                    foregroundColor: theme
                        .elevatedButtonTheme.style?.foregroundColor
                        ?.resolve({}),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              // More from this category
              Text(
                'More from this category',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: isLoadingRelated
                    ? Center(child: CircularProgressIndicator())
                    : relatedProducts.isEmpty
                        ? Text('No other products found.',
                            style: GoogleFonts.inter(
                                color: theme.textTheme.bodyMedium?.color))
                        : SizedBox(
                            height: 180,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedProducts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final rel = relatedProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/product-details',
                                        arguments: rel);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(18),
                                      border:
                                          Border.all(color: theme.dividerColor),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        rel['image'] != null
                                            ? Hero(
                                                tag: 'product_${rel['id']}',
                                                child: Image.network(
                                                    getFullImageUrl(
                                                        rel['image']),
                                                    height: 60,
                                                    fit: BoxFit.contain))
                                            : Icon(Icons.image,
                                                size: 40,
                                                color: theme.iconTheme.color
                                                    ?.withOpacity(0.3)),
                                        const SizedBox(height: 10),
                                        Text(
                                          rel['name'] ?? '',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            color: theme
                                                .textTheme.bodyLarge?.color,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          rel['price'] != null
                                              ? '\$${rel['price']}'
                                              : '',
                                          style: GoogleFonts.inter(
                                            color: theme
                                                .textTheme.bodyMedium?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
              // Show wishlist info if this product is in wishlist
              Obx(() {
                final isFav = wishlistController.isFavorite(product!['id']);
                if (!isFav) return SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: theme.primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text('In your wishlist',
                          style: GoogleFonts.inter(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
