import 'package:check/payment/pay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../presentation/controllers/cart_controller.dart';
import '../../presentation/controllers/theme_controller.dart';
import './modern_app_bar.dart';
import './error_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/ui_constants.dart';
import './cart_icon_with_badge.dart';
import './animated_button.dart';

// Move getFullImageUrl above CartView so it is accessible in itemBuilder
String getFullImageUrl(String? url) {
  return 'https://res.cloudinary.com/dkiuz3gfn/image/upload/v1/ $url';
}

class CartView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final RxInt updatingItemId = (-1).obs;
  final TextEditingController couponController = TextEditingController();
  final currency = NumberFormat.simpleCurrency(name: 'USD');

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: ModernAppBar(
          title: 'Cart',
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
        body: Stack(
          children: [
            Obx(() {
              if (cartController.error.isNotEmpty) {
                return ErrorDisplay(
                  message:
                      'Failed to load your cart. Please check your connection and try again.',
                  onRetry: () => cartController.fetchCart(),
                );
              }
              final items = cartController.items;
              if (cartController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 100,
                          color: theme.primaryColor.withOpacity(0.15)),
                      SizedBox(height: kSectionSpacing),
                      Text('Your cart is empty',
                          style: GoogleFonts.inter(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: kItemSpacing),
                      Text('Looks like you haven\'t added anything yet.',
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6))),
                      SizedBox(height: kSectionSpacing),
                      AnimatedButton(
                        onTap: () => Get.offAllNamed('/products'),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.storefront),
                          label: Text('Shop Now',
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
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                );
              }
              // Calculate totals
              final totalItems = items.fold<int>(
                  0, (sum, item) => sum + ((item['quantity'] ?? 0) as int));
              final totalPrice = items.fold<double>(
                  0,
                  (sum, item) =>
                      sum +
                      ((double.tryParse(
                                  item['product_price']?.toString() ?? '0') ??
                              0.0) *
                          (item['quantity'] ?? 0)));
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(kPagePadding,
                          kPagePadding, kPagePadding, kItemSpacing),
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: kItemSpacing),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final itemId = item['id'] ?? -1;
                        final name = item['product_name'] ?? '';
                        final price = double.tryParse(
                                item['product_price']?.toString() ?? '0') ??
                            0.0;
                        final qty = item['quantity'] ?? 1;
                        final subtotal = price * qty;
                        final image = item['product_image'] ?? '';
                        final isUpdating = updatingItemId.value == itemId;
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kCardRadius)),
                          child: Padding(
                            padding: const EdgeInsets.all(kCardPadding),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                image.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: getFullImageUrl(image),
                                          height: 56,
                                          width: 56,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: 56,
                                            width: 56,
                                            decoration: BoxDecoration(
                                              color: theme.dividerColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.broken_image,
                                                  size: 48,
                                                  color: theme.iconTheme.color
                                                      ?.withOpacity(0.3)),
                                        ),
                                      )
                                    : Icon(Icons.image,
                                        size: 48,
                                        color: theme.iconTheme.color
                                            ?.withOpacity(0.3)),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(name,
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(currency.format(price),
                                          style: GoogleFonts.inter(
                                              color: theme.textTheme.bodyMedium
                                                  ?.color)),
                                      Text(
                                          'Subtotal: ${currency.format(subtotal)}',
                                          style: GoogleFonts.inter(
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        AnimatedButton(
                                          onTap: !isUpdating && qty > 1
                                              ? () async {
                                                  updatingItemId.value = itemId;
                                                  await cartController
                                                      .updateCartItemQuantity(
                                                          itemId, qty - 1);
                                                  updatingItemId.value = -1;
                                                }
                                              : null,
                                          child: IconButton(
                                            icon: isUpdating
                                                ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 2))
                                                : Icon(Icons
                                                    .remove_circle_outline),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Text('$qty',
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold)),
                                        AnimatedButton(
                                          onTap: () {
                                            // Only update locally, no backend request
                                            cartController.items[index]
                                                    ['quantity'] =
                                                (cartController.items[index]
                                                            ['quantity'] ??
                                                        1) +
                                                    1;
                                            cartController.items.refresh();
                                          },
                                          child: IconButton(
                                            icon:
                                                Icon(Icons.add_circle_outline),
                                            onPressed: () {
                                              cartController.items[index]
                                                      ['quantity'] =
                                                  (cartController.items[index]
                                                              ['quantity'] ??
                                                          1) +
                                                      1;
                                              cartController.items.refresh();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Remove Item',
                                                style: GoogleFonts.inter(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            content: Text(
                                                'Are you sure you want to remove this item from your cart?',
                                                style: GoogleFonts.inter()),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text('Cancel',
                                                    style: GoogleFonts.inter()),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: Text('Remove',
                                                    style: GoogleFonts.inter(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          updatingItemId.value = itemId;
                                          await cartController
                                              .removeFromCart(itemId);
                                          updatingItemId.value = -1;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: kItemSpacing),
                  // Coupon code input
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kPagePadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: couponController,
                            decoration: InputDecoration(
                              hintText: 'Enter coupon code',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(kCardRadius)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            // UI only, no backend logic
                            Get.snackbar('Coupon', 'Coupon applied (UI only)',
                                snackPosition: SnackPosition.BOTTOM);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kCardRadius)),
                          ),
                          child: Text('Apply'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: kItemSpacing),
                  // Estimated delivery
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kPagePadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Delivery:',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6))),
                        Text('2-4 days',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  SizedBox(height: kSectionSpacing),
                  // Cart summary
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kPagePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Items:',
                                style: GoogleFonts.inter(fontSize: 16)),
                            Text('$totalItems',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: kItemSpacing),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Price:',
                                style: GoogleFonts.inter(
                                    fontSize: 18, color: theme.primaryColor)),
                            Text(currency.format(totalPrice),
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: theme.primaryColor)),
                          ],
                        ),
                        SizedBox(height: kItemSpacing),
                        SizedBox(
                          height: 56,
                          child: AnimatedButton(
                            onTap: () async {
                              final confirmed = await showDialog<bool>(
                                context: Get.context!,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirm Payment',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold)),
                                  content: Text(
                                      'Proceed to pay ${currency.format(totalPrice)}?',
                                      style: GoogleFonts.inter()),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel',
                                          style: GoogleFonts.inter()),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.primaryColor,
                                        foregroundColor:
                                            theme.colorScheme.onPrimary,
                                      ),
                                      child: Text('Pay',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                showDialog(
                                  context: Get.context!,
                                  barrierDismissible: false,
                                  builder: (context) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                try {
                                  await Stripeservice.instance
                                      .makePayment(totalPrice.round());
                                  Navigator.of(Get.context!)
                                      .pop(); // remove loader
                                  // After payment, perform checkout (creates order, clears cart, navigates to orders)
                                  await cartController.checkout();
                                } catch (e) {
                                  Navigator.of(Get.context!).pop();
                                  Get.snackbar('Payment Failed', e.toString());
                                }
                              }
                            },
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(kCardRadius)),
                                elevation: 2,
                                padding: EdgeInsets.symmetric(
                                    vertical: kItemSpacing),
                              ),
                              onPressed: null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.payment),
                                  SizedBox(width: 8),
                                  Text('Checkout',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            Obx(() => cartController.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.05),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
