import 'package:get/get.dart';
import '../services/api_service.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  final api = ApiService();
  final box = GetStorage();

  @override
  void onInit() {
    print('🚀 AuthController initialized');
    super.onInit();
  }

  Future<void> login(String username, String password) async {
    print('🔄 AuthController: Starting login for user: $username');
    isLoading.value = true;
    error.value = '';
    try {
      final data = await api.login(username, password);
      if (data['token'] != null) {
        print('✅ AuthController: Login successful, saving token');
        await box.write('token', data['token']);
        print('📊 AuthController: Token saved to storage');
        Get.offAllNamed('/main-nav');
        print('🔄 AuthController: Navigated to main navigation');
      } else {
        print('❌ AuthController: Login failed - no token');
        error.value = data['error'] ?? 'Login failed';
      }
    } catch (e) {
      print('❌ AuthController: Login error: $e');
      error.value = e.toString().replaceAll('Exception: ', '');
    }
    isLoading.value = false;
    print('🔄 AuthController: Login process completed');
  }

  Future<void> signup(String username, String email, String password) async {
    print('🔄 AuthController: Starting signup for user: $username');
    isLoading.value = true;
    error.value = '';
    try {
      final data = await api.signup(username, email, password);
      if (data != null && data['token'] != null) {
        print('✅ AuthController: Signup successful, saving token');
        await box.write('token', data['token']);
        print('📊 AuthController: Token saved to storage');
        Get.offAllNamed('/main-nav');
        print('🔄 AuthController: Navigated to main navigation');
      } else {
        print('❌ AuthController: Signup failed - no token');
        error.value = (data != null && data['error'] != null)
            ? data['error']
            : 'Signup failed';
      }
    } catch (e) {
      print('❌ AuthController: Signup error: $e');
      error.value = e.toString().replaceAll('Exception: ', '').replaceAll(
          'Null check operator used on a null value',
          'Signup failed: Unexpected error.');
    }
    isLoading.value = false;
    print('🔄 AuthController: Signup process completed');
  }

  Future<void> logout() async {
    print('🔄 AuthController: Starting logout process');
    try {
      await api.logout();
      print('✅ AuthController: Logout API call successful');
    } catch (e) {
      print('⚠️ AuthController: Logout API call failed, but continuing: $e');
    }
    box.remove('token');
    print('📊 AuthController: Token removed from storage');
    Get.offAllNamed('/login');
    print('🔄 AuthController: Navigated to login page');
  }

  bool get isLoggedIn {
    final token = box.read('token');
    print(
        '📊 AuthController: Checking login status - Token exists: ${token != null}');
    return token != null;
  }
}
