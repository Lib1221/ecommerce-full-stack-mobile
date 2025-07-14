import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cart_controller.dart';

String getFullImageUrl(String? url) {
  if (url == null) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  if (url.startsWith('/')) return 'http://localhost:8000$url';
  return url;
}

class CartView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final RxInt updatingItemId = (-1).obs; // Track which item is being updated

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
            'Cart',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Obx(() {
              final items = cartController.items;
              if (cartController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (items.isEmpty) {
                return Center(
                  child: Text('Your cart is empty',
                      style: GoogleFonts.inter(fontSize: 18)),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final itemId = (item['id'] is int && item['id'] != null)
                            ? item['id'] as int
                            : -1;
                        final price = double.tryParse(
                                item['product_price']?.toString() ?? '0') ??
                            0.0;
                        final qty = (item['quantity'] is int &&
                                item['quantity'] != null)
                            ? item['quantity'] as int
                            : 1;
                        final subtotal = price * qty;
                        final isUpdating = updatingItemId.value == itemId;
                        final canUpdate = itemId != -1 && qty > 0;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              item['product_image'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        getFullImageUrl(item['product_image']),
                                        height: 56,
                                        width: 56,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.image,
                                      size: 48,
                                      color: theme.iconTheme.color
                                          ?.withOpacity(0.3)),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['product_name'] ?? '',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['product_price'] != null
                                          ? '\$${item['product_price']}'
                                          : '',
                                      style: GoogleFonts.inter(
                                        color:
                                            theme.textTheme.bodyMedium?.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    if (itemId == -1)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: Text('Invalid cart item',
                                            style: GoogleFonts.inter(
                                                color: Colors.red,
                                                fontSize: 12)),
                                      ),
                                  ],
                                ),
                              ),
                              // Quantity controls
                              Row(
                                children: [
                                  IconButton(
                                    icon: isUpdating
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2))
                                        : Icon(Icons.remove_circle_outline,
                                            color: theme.iconTheme.color),
                                    onPressed:
                                        !canUpdate || isUpdating || qty <= 1
                                            ? null
                                            : () async {
                                                updatingItemId.value = itemId;
                                                await cartController
                                                    .updateCartItemQuantity(
                                                        itemId, qty - 1);
                                                updatingItemId.value = -1;
                                              },
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    transitionBuilder: (child, anim) =>
                                        ScaleTransition(
                                            scale: anim, child: child),
                                    child: Text(
                                      '$qty',
                                      key: ValueKey(qty),
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    icon: isUpdating
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2))
                                        : Icon(Icons.add_circle_outline,
                                            color: theme.iconTheme.color),
                                    onPressed: !canUpdate || isUpdating
                                        ? null
                                        : () async {
                                            updatingItemId.value = itemId;
                                            await cartController
                                                .updateCartItemQuantity(
                                                    itemId, qty + 1);
                                            updatingItemId.value = -1;
                                          },
                                  ),
                                ],
                              ),
                              // Remove button with confirmation
                              IconButton(
                                icon: Icon(Icons.delete_outline,
                                    color: theme.iconTheme.color),
                                onPressed: !canUpdate
                                    ? null
                                    : () async {
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
                        );
                      },
                    ),
                  ),
                  // Spacer for sticky summary
                  SizedBox(height: 90),
                ],
              );
            }),
            // Sticky cart summary bar
            Obx(() {
              final items = cartController.items;
              if (items.isEmpty) return SizedBox.shrink();
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Items:',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: theme.textTheme.bodyMedium?.color)),
                          Text('${cartController.totalItems}',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Price:',
                              style: GoogleFonts.inter(
                                  fontSize: 18, color: theme.primaryColor)),
                          Text(
                              ' 24${cartController.totalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: theme.primaryColor)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cartController.checkout();
                          },
                          icon: Icon(Icons.payment, size: 22),
                          label: Text('Checkout',
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
                    ],
                  ),
                ),
              );
            }),
            // Loading overlay for cart actions
            Obx(() => cartController.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.08),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
