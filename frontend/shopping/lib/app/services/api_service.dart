import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/';
  final box = GetStorage();

  // Helper method to get headers with authentication
  Map<String, String> _getHeaders() {
    final token = box.read('token');
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }
    return headers;
  }

  // Helper method to handle HTTP responses for Map data
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // Helper method to handle HTTP responses for List data
  List _handleListResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      // Handle both direct list and paginated response
      if (data is List) {
        return data;
      } else if (data is Map && data.containsKey('results')) {
        return data['results'];
      } else {
        return [];
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // New API endpoints
  Future<Map<String, dynamic>> signup(
      String username, String email, String password) async {
    try {
      print('🔄 Signing up user: $username');
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/auth/signup/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode >= 400) {
        print('❌ Signup error: ${response.body}');
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Signup failed');
      }
      final data = _handleResponse(response);
      print('✅ Signup successful:');
      print('📊 Response: $data');

      // Store token if provided
      if (data['token'] != null) {
        box.write('token', data['token']);
        print('🔐 Token stored: ${data['token']}');
      }

      return data;
    } catch (e) {
      print('❌ Error during signup: $e');
      throw Exception('Failed to signup: $e');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔄 Logging in user: $username');
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      final data = _handleResponse(response);
      print('✅ Login successful:');
      print('📊 Response: $data');

      // Store token
      if (data['token'] != null) {
        box.write('token', data['token']);
        print('🔐 Token stored: ${data['token']}');
      }

      return data;
    } catch (e) {
      print('❌ Error during login: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      print('🔄 Logging out user');
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/auth/logout/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
      print('✅ Logout successful:');
      print('📊 Response: $data');

      // Clear stored token
      box.remove('token');
      print('🔐 Token cleared');
    } catch (e) {
      print('❌ Error during logout: $e');
      throw Exception('Logout failed: $e');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      print('🔄 Fetching user profile');
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/auth/profile/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
      print('✅ User profile fetched successfully:');
      print('📊 Response: $data');
      return data;
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<List> fetchProducts() async {
    try {
      print('🔄 Fetching products from: ${baseUrl}shop/api/shop/products/');
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/products/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      print('✅ Products fetched successfully:');
      print('📊 Total products: ${data.length}');
      return data;
    } catch (e) {
      print('❌ Error fetching products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Map<String, dynamic>> getProductDetail(int productId) async {
    try {
      print('🔄 Fetching product detail for ID: $productId');
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/products/$productId/detail/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
      print('✅ Product detail fetched successfully:');
      print('📊 Response: $data');
      return data;
    } catch (e) {
      print('❌ Error fetching product detail: $e');
      throw Exception('Failed to fetch product detail: $e');
    }
  }

  Future<List> getProductsByCategory(int categoryId) async {
    try {
      print('🔄 Fetching products for category: $categoryId');
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/categories/$categoryId/products/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      print('✅ Category products fetched successfully:');
      print('📊 Total products: ${data.length}');
      return data;
    } catch (e) {
      print('❌ Error fetching category products: $e');
      throw Exception('Failed to fetch category products: $e');
    }
  }

  Future<List> fetchCart() async {
    try {
      print('🔄 Fetching cart items');
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/cart/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      print('✅ Cart items fetched successfully:');
      print('📊 Total cart items: ${data.length}');
      return data;
    } catch (e) {
      print('❌ Error fetching cart: $e');
      throw Exception('Failed to fetch cart: $e');
    }
  }

  Future<Map<String, dynamic>> addToCart(int productId, int quantity) async {
    try {
      print('🔄 Adding product $productId to cart with quantity $quantity');
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/cart/add/'),
        headers: _getHeaders(),
        body: jsonEncode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );
      final data = _handleResponse(response);
      print('✅ Product added to cart successfully:');
      print('📊 Response: $data');
      return data;
    } catch (e) {
      print('❌ Error adding to cart: $e');
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<Map<String, dynamic>> updateCartItem(int itemId, int quantity) async {
    try {
      print('🔄 Updating cart item $itemId quantity to: $quantity');
      final response = await http.put(
        Uri.parse('${baseUrl}shop/api/shop/cart/update/$itemId/'),
        headers: _getHeaders(),
        body: jsonEncode({'quantity': quantity}),
      );
      final data = _handleResponse(response);
      print('✅ Cart item updated successfully:');
      print('📊 Response: $data');
      return data;
    } catch (e) {
      print('❌ Error updating cart item: $e');
      throw Exception('Failed to update cart item: $e');
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      print('🔄 Removing cart item: $itemId');
      final response = await http.delete(
        Uri.parse('${baseUrl}shop/api/shop/cart/remove/$itemId/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
      print('✅ Cart item removed successfully:');
      print('📊 Response: $data');
    } catch (e) {
      print('❌ Error removing from cart: $e');
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Future<Map<String, dynamic>> checkout() async {
    try {
      print('🔄 Processing checkout');
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/cart/checkout/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
      print('✅ Checkout successful:');
      print('📊 Response: $data');
      return data;
    } catch (e) {
      print('❌ Error during checkout: $e');
      throw Exception('Checkout failed: $e');
    }
  }

  Future<List> fetchOrders() async {
    try {
      print('🔄 Fetching user orders');
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/orders/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      print('✅ User orders fetched successfully:');
      print('📊 Total orders: ${data.length}');
      return data;
    } catch (e) {
      print('❌ Error fetching orders: $e');
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<List> fetchCategories() async {
    try {
      print('🔄 Fetching categories');
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/categories/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      print('✅ Categories fetched successfully:');
      print('📊 Total categories: ${data.length}');
      return data;
    } catch (e) {
      print('❌ Error fetching categories: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Legacy methods for backward compatibility
  Future<List> fetchHomepageProducts() async {
    return fetchProducts();
  }

  Future<void> updateCartItemQuantity(int itemId, int quantity) async {
    await updateCartItem(itemId, quantity);
  }

  Future<Map<String, dynamic>> createOrder() async {
    return checkout();
  }
}
