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
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Signup failed');
      }
      final data = _handleResponse(response);

      // Store token if provided
      if (data['token'] != null) {
        box.write('token', data['token']);
      }

      return data;
    } catch (e) {
      throw Exception('Failed to signup: $e');
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      final data = _handleResponse(response);

      // Store token
      if (data['token'] != null) {
        box.write('token', data['token']);
      }

      return data;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/auth/logout/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);

      // Clear stored token
      box.remove('token');
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/auth/profile/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
      return data;
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<List> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/products/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      return data;
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Map<String, dynamic>> getProductDetail(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/products/$productId/detail/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
      return data;
    } catch (e) {
      throw Exception('Failed to fetch product detail: $e');
    }
  }

  Future<List> getProductsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/categories/$categoryId/products/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      return data;
    } catch (e) {
      throw Exception('Failed to fetch category products: $e');
    }
  }

  Future<List> fetchCart() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/cart/items/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      return data;
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  Future<Map<String, dynamic>> addToCart(int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/cart/add/'),
        headers: _getHeaders(),
        body: jsonEncode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );
      final data = _handleResponse(response);
      return data;
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<Map<String, dynamic>> updateCartItem(int itemId, int quantity) async {
    try {
      final response = await http.put(
        Uri.parse('${baseUrl}shop/api/shop/cart/update/$itemId/'),
        headers: _getHeaders(),
        body: jsonEncode({'quantity': quantity}),
      );
      final data = _handleResponse(response);
      return data;
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}shop/api/shop/cart/remove/$itemId/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Future<Map<String, dynamic>> checkout() async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}shop/api/shop/cart/checkout/'),
        headers: _getHeaders(),
      );
      final data = _handleResponse(response);
      return data;
    } catch (e) {
      throw Exception('Checkout failed: $e');
    }
  }

  Future<List> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/orders/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      return data;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<List> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}shop/api/shop/categories/'),
        headers: _getHeaders(),
      );
      final data = _handleListResponse(response);
      return data;
    } catch (e) {
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
