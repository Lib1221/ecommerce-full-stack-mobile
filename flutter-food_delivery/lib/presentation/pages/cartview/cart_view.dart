import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/theme_controller.dart';
import '../modern_app_bar.dart';
import '../error_display.dart';
import '../cart_icon_with_badge.dart';
import '../../../core/ui_constants.dart';
import 'cart_item_tile.dart';
import 'cart_empty.dart';
import 'cart_summary.dart';
import 'package:check/payment/pay.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final RxInt updatingItemId = (-1).obs;
  final TextEditingController couponController = TextEditingController();
  final currency = NumberFormat.simpleCurrency(name: 'USD');

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    cartController.clearError();
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: ModernAppBar(
          title: 'Cart',
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh Cart',
              onPressed: () => cartController.fetchCart(),
            ),
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
                return const CartEmpty();
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
                        final isUpdating = updatingItemId.value == itemId;
                        return CartItemTile(
                          item: item,
                          isUpdating: isUpdating,
                          onRemove: () async {
                            updatingItemId.value = itemId;
                            await cartController.removeFromCart(itemId);
                            updatingItemId.value = -1;
                          },
                          onUpdateQty: (newQty) async {
                            updatingItemId.value = itemId;
                            await cartController.updateCartItemQuantity(
                                itemId, newQty);
                            updatingItemId.value = -1;
                          },
                        );
                      },
                    ),
                  ),
                  CartSummary(
                    totalItems: totalItems,
                    totalPrice: totalPrice,
                    onPay: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                      try {
                        await Stripeservice.instance
                            .makePayment(totalPrice.round());
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop(); // remove loader
                        }
                        // Do not call checkout here; handled in Stripe service
                      } catch (e) {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment failed: $e')),
                        );
                      }
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
