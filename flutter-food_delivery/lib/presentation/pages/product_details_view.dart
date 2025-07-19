import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/controllers/cart_controller.dart';
import '../../presentation/controllers/wishlist_controller.dart';
import '../../presentation/controllers/theme_controller.dart';
import '../../data/services/api_service.dart';
import './modern_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/ui_constants.dart';
import './cart_icon_with_badge.dart';
import './animated_button.dart';

class ProductDetailsView extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final CartController cartController = Get.find<CartController>();
  final ApiService api = ApiService();
  final WishlistController wishlistController = Get.find<WishlistController>();
  final ThemeController themeController = Get.find<ThemeController>();
  Map<String, dynamic>? product;
  List<dynamic> relatedProducts = [];
  bool isLoadingRelated = true;

  @override
  void initState() {
    super.initState();
    product = widget.product;
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
        appBar: ModernAppBar(
          title: 'Product Details',
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
            Obx(() {
              final isFav = wishlistController.isFavorite(product!['id']);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : theme.iconTheme.color,
                  size: 28,
                ),
                onPressed: () {
                  if (isFav) {
                    wishlistController.removeFromWishlist(product!['id']);
                  } else {
                    wishlistController.addToWishlist(product!['id']);
                  }
                  setState(() {});
                },
                tooltip: isFav ? 'Remove from Wishlist' : 'Add to Wishlist',
              );
            }),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(kPagePadding),
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
                    borderRadius: BorderRadius.circular(kCardRadius),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: product!['image'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(kCardRadius),
                          child: CachedNetworkImage(
                            imageUrl: getFullImageUrl(product!['image']),
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              height: 220,
                              decoration: BoxDecoration(
                                color: theme.dividerColor,
                                borderRadius:
                                    BorderRadius.circular(kCardRadius),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                                Icons.broken_image,
                                size: 80,
                                color: theme.iconTheme.color?.withOpacity(0.2)),
                          ),
                        )
                      : Icon(Icons.image,
                          size: 80,
                          color: theme.iconTheme.color?.withOpacity(0.2)),
                ),
              ),
              SizedBox(height: kSectionSpacing),
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
              SizedBox(height: kItemSpacing),
              // Price
              Text(
                product!['price'] != null ? '\$${product!['price']}' : '',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(height: kSectionSpacing),
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
              SizedBox(height: kSectionSpacing),
              // Add to Cart Button
              AnimatedButton(
                onTap: () {
                  cartController.addToCart(product!['id']);
                },
                child: ElevatedButton.icon(
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
                        borderRadius: BorderRadius.circular(kCardRadius)),
                    elevation: 0,
                  ),
                  onPressed: null,
                ),
              ),
              SizedBox(height: kSectionSpacing),
              // More from this category
              Text(
                'More from this category',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: kItemSpacing),
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
                                  SizedBox(width: kItemSpacing),
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
                                      borderRadius:
                                          BorderRadius.circular(kCardRadius),
                                      border:
                                          Border.all(color: theme.dividerColor),
                                    ),
                                    padding: const EdgeInsets.all(kCardPadding),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        rel['image'] != null
                                            ? Hero(
                                                tag: 'product_${rel['id']}',
                                                child: CachedNetworkImage(
                                                  imageUrl: getFullImageUrl(
                                                      rel['image']),
                                                  height: 60,
                                                  fit: BoxFit.contain,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: theme.dividerColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Icon(Icons.broken_image,
                                                          size: 40,
                                                          color: theme
                                                              .iconTheme.color
                                                              ?.withOpacity(
                                                                  0.3)),
                                                ),
                                              )
                                            : Icon(Icons.image,
                                                size: 40,
                                                color: theme.iconTheme.color
                                                    ?.withOpacity(0.3)),
                                        SizedBox(height: kItemSpacing),
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
                                        SizedBox(height: kItemSpacing),
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
                      SizedBox(width: kItemSpacing),
                      Text('In your wishlist',
                          style: GoogleFonts.inter(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                );
              }),
              SizedBox(height: kSectionSpacing),
              // Product Reviews Template
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Reviews',
                        style: GoogleFonts.inter(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: kSectionSpacing),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(kCardRadius),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Center(
                        child: Text(
                          'No reviews yet. Be the first to review this product!',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: kItemSpacing),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.rate_review),
                      label: Text('Add a Review',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kCardRadius)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kSectionSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
