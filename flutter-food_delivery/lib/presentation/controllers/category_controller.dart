import 'package:get/get.dart';
import '../../data/services/api_service.dart';

class CategoryController extends GetxController {
  var categories = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final api = ApiService();

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      error.value = '';
      categories.value = await api.fetchCategories();
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    error.value = '';
  }
}
