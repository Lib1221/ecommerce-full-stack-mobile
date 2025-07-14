import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends StatelessWidget {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Your Cart',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => cartController.refreshCart(),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (cartController.items.isEmpty) return SizedBox.shrink();
            final cart = cartController.items[0];
            final items = cart['items'] ?? [];
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await cartController.refreshCart();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16),
                        leading: item['product_image'] != null
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(item['product_image']),
                                backgroundColor: Colors.deepPurple.shade100,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.deepPurple.shade100,
                                child: const Icon(Icons.shopping_bag,
                                    color: Colors.deepPurple),
                              ),
                        title: Text(
                          item['product_name'] ?? 'Product',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity: ${item['quantity']}'),
                            Text(
                              '${item['product_price']?.toString() ?? '0.00'}',
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Remove Item'),
                                content: const Text(
                                    'Are you sure you want to remove this item from your cart?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      cartController.removeFromCart(item['id']);
                                    },
                                    child: const Text('Remove',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
          // Summary and Checkout
          Obx(() {
            if (cartController.items.isEmpty) return const SizedBox.shrink();
            final cart = cartController.items[0];
            final items = cart['items'] ?? [];
            double total = 0.0;
            for (var item in items) {
              final price =
                  double.tryParse(item['product_price']?.toString() ?? '0') ??
                      0.0;
              final qty = item['quantity'] ?? 0;
              total += price * qty;
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Items:',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey.shade700)),
                      Text('${cart['total_items']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Price:',
                          style: TextStyle(
                              fontSize: 18, color: Colors.deepPurple)),
                      Text(total.toStringAsFixed(2),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.deepPurple)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => cartController.checkout(),
                      icon: const Icon(Icons.payment),
                      label: const Text('Checkout',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
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
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
