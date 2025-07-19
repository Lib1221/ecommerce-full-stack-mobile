import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  final api = ApiService();
  final box = GetStorage();

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    error.value = '';
    try {
      final data = await api.login(username, password);
      if (data['token'] != null) {
        await box.write('token', data['token']);
        Get.offAllNamed('/main-nav');
      } else {
        error.value = data['error'] ?? 'Login failed';
      }
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    }
    isLoading.value = false;
  }

  Future<void> signup(String username, String email, String password) async {
    isLoading.value = true;
    error.value = '';
    try {
      final data = await api.signup(username, email, password);
      if (data['token'] != null) {
        await box.write('token', data['token']);
        Get.offAllNamed('/main-nav');
      } else {
        error.value = (data['error'] != null) ? data['error'] : 'Signup failed';
      }
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '').replaceAll(
          'Null check operator used on a null value',
          'Signup failed: Unexpected error.');
    }
    isLoading.value = false;
  }

  Future<void> logout() async {
    try {
      await api.logout();
      // ignore: empty_catches
    } catch (e) {}
    box.remove('token');
    Get.offAllNamed('/login');
  }

  bool get isLoggedIn {
    final token = box.read('token');
    return token != null;
  }

  void clearError() {
    error.value = '';
  }
}
