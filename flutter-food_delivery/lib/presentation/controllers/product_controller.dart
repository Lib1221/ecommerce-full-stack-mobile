import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import 'package:flutter/material.dart';

class ProductController extends GetxController {
  var products = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final api = ApiService();

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      error.value = '';
      products.value = await api.fetchProducts();
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
    Get.snackbar(
      'Success',
      'Products refreshed!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void clearError() {
    error.value = '';
  }
}
