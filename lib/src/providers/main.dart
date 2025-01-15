import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:qr_admin/src/models/category.dart';
import '../api.dart';
import '../models/product.dart';
import '../models/user.dart';

final db = Localstore.instance;

class MainProvider with ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearToken() {
    _token = null;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void logout() {
    clearToken();
    clearUser();
    db.collection('auth').doc('user').delete();
    db.collection('auth').doc('token').delete();
  }

  bool isAuthenticated() {
    return _user != null;
  }

  Future<User?> getRemoteUser() async {
    final response = await apiClient.get('/api/auth/user');

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      final user = User(
          id: responseData['data']['id'],
          email: responseData['data']['email'],
          isEmailVerified: responseData['data']['email_verified'],
          name: responseData['data']['name'],
          businessName: responseData['data']['business_name'],
          taxOffice: responseData['data']['tax_office'],
          taxNumber: responseData['data']['tax_number'],
          phone: responseData['data']['phone'],
          address: responseData['data']['address'],
          logoURL: responseData['data']['logo_url']);
      setUser(user);
      return user;
    } else {
      logout();
      return null;
    }
  }

  Future<String> login(String email, String password) async {
    final response = await apiClient.post(
      '/api/auth/token',
      {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      await db.collection('auth').doc('user').set({
        'id': responseData['user']['id'],
        'email': responseData['user']['email'],
        'email_verified': responseData['user']['email_verified']
      });
      await db
          .collection('auth')
          .doc('token')
          .set({'token': responseData['token']});
      final user = User(
          id: responseData['user']['id'], email: responseData['user']['email']);
      setUser(user);
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> forgot_password(String email) async {
    final response =
        await apiClient.post('/api/auth/forgot-password', {'email': email});

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> reset_password(String key, String password) async {
    final response = await apiClient
        .post('/api/auth/reset-password', {'code': key, 'password': password});

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> password_change(
      String currentPassword, String newPassword) async {
    final response = await apiClient.post('/api/auth/change-password',
        {'old_password': currentPassword, 'new_password': newPassword});

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> resend_verification_code() async {
    final response = await apiClient.get('/api/auth/send_verification_code');

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> verify_email(String key) async {
    final response =
        await apiClient.post('/api/auth/verify_email', {'code': key});

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      await db.collection('auth').doc('user').set({
        'id': responseData['data']['id'],
        'email': responseData['data']['email'],
        'email_verified': responseData['data']['email_verified']
      });

      final user = User(
          id: responseData['data']['id'],
          email: responseData['data']['email'],
          isEmailVerified: true);
      setUser(user);
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> register(Map<String, dynamic> data) async {
    final response = await apiClient.post('/api/auth/register', data);

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> update_profile(Map<String, dynamic> data) async {
    final response = await apiClient.post('/api/auth/profile', data);

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> uploadAvatar(Uint8List image) async {
    final response = await apiClient.post("/api/auth/avatar", {'image': image});
    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<Uint8List> getImage(String url) async {
    final response = await apiClient.get(url);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return Uint8List(0);
    }
  }

  Future<void> createCategory(String name, Uint8List image) async {
    try {
      final response = await apiClient
          .post('/api/categories', {'name': name, 'image': image});
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to create category');
      }
    } catch (error) {
      throw Exception('Failed to create category: $error');
    }
  }

  Future<Category> getCategory(int id) async {
    final response = await apiClient.get('/api/categories/$id');

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return Category.fromJson(data);
    } else {
      throw Exception('Failed to get category');
    }
  }

  Future<void> updateCategory(int id, String name, Uint8List image) async {
    try {
      final response = await apiClient.put('/api/categories/$id',
          {'name': name, 'image': image});
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to update category');
      }
    } catch (error) {
      throw Exception('Failed to update category: $error');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final response = await apiClient.delete('/api/categories/$id');
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to delete category');
      }
    } catch (error) {
      throw Exception('Failed to delete category: $error');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await apiClient.get('/api/categories');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      _categories = data.map((json) {
        return Category.fromJson(json);
      }).toList();
      notifyListeners();
      return categories;
    } else {
      return [];
    }
  }

  Future<List<Product>> fetchProducts(int categoryId) async {
    final response = await apiClient.get('/api/products/$categoryId');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) {
        return Product.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> createProduct(int categoryId, String name, String description, double price, Uint8List image) async {
    try {
      final response = await apiClient.post('/api/products',
          {'category_id': categoryId, 'name': name, 'description': description, 'price': price, 'image': image});
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to create product');
      }
    } catch (error) {
      throw Exception('Failed to create product: $error');
    }
  }

  Future<Product> getProduct(int id) async {
    final response = await apiClient.get('/api/product/$id');

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to get product');
    }
  }

  Future<void> updateProduct(int id, String name, String description, double price, Uint8List image) async {
    try {
      final response = await apiClient.put('/api/products/$id',
          {'name': name, 'description': description, 'price': price, 'image': image});
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to update product');
      }
    } catch (error) {
      throw Exception('Failed to update product: $error');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await apiClient.delete('/api/products/$id');
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      throw Exception('Failed to delete product: $error');
    }
  }
}
