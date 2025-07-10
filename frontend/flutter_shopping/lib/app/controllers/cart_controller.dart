import 'package:get/get.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';
import '../views/order_history_view.dart';

class CartController extends GetxController {
  var items = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final api = ApiService();
  var lastAddedItem = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      error.value = '';
      items.value = await api.fetchCart();
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCart() async {
    await fetchCart();
    Get.snackbar(
      'Success',
      'Cart refreshed!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  Future<void> addToCart(int productId, {int quantity = 1}) async {
    try {
      final response = await api.addToCart(productId, quantity);
      lastAddedItem.value = response['cart_item'];
      await fetchCart(); // Refresh cart after adding item
      Get.snackbar(
        'Success',
        'Added to cart!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add to cart: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateCartItemQuantity(int itemId, int quantity) async {
    try {
      await api.updateCartItem(itemId, quantity);
      await fetchCart(); // Refresh cart after updating item
      Get.snackbar(
        'Success',
        'Cart updated!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update cart: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      await api.removeFromCart(itemId);
      await fetchCart(); // Refresh cart after removing item
      Get.snackbar(
        'Success',
        'Item removed from cart!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> checkout() async {
    try {
      isLoading.value = true;
      await api.checkout();
      items.value = []; // Clear cart in UI immediately
      await fetchCart(); // Refresh cart after checkout
      // Refresh orders after checkout
      if (Get.isRegistered<OrderController>()) {
        Get.find<OrderController>().fetchOrders();
      }
      Get.snackbar(
        'Success',
        'Order placed successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      // Navigate to orders page
      Get.offAllNamed('/orders');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Checkout failed: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    error.value = '';
  }

  // Helper method to calculate total items in cart
  int get totalItems {
    int total = 0;
    for (var item in items) {
      total += (item['quantity'] ?? 0) as int;
    }
    return total;
  }

  // Helper method to calculate total price
  double get totalPrice {
    double total = 0.0;
    for (var item in items) {
      double price =
          double.tryParse(item['product_price']?.toString() ?? '0') ?? 0.0;
      int quantity = item['quantity'] ?? 0;
      total += price * quantity;
    }
    return total;
  }
}
