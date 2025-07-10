import 'package:get/get.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';

class ProductController extends GetxController {
  var products = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final api = ApiService();

  @override
  void onInit() {
    print('🚀 ProductController initialized');
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      print('🔄 ProductController: Starting to fetch products');
      isLoading.value = true;
      error.value = '';
      products.value = await api.fetchProducts();
      print('✅ ProductController: Products updated in state');
      print('📊 ProductController: Current products count: ${products.length}');
    } catch (e) {
      print('❌ ProductController: Error fetching products: $e');
      error.value = e.toString().replaceAll('Exception: ', '');
      print('📊 ProductController: Error state updated: ${error.value}');
    } finally {
      isLoading.value = false;
      print('🔄 ProductController: Loading state set to false');
    }
  }

  Future<void> refreshProducts() async {
    print('🔄 ProductController: Refreshing products');
    await fetchProducts();
    Get.snackbar(
      'Success',
      'Products refreshed!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
    print('✅ ProductController: Refresh completed with success message');
  }

  void clearError() {
    print('🔄 ProductController: Clearing error state');
    error.value = '';
  }
}
