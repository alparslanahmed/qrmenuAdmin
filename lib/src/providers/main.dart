import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import '../api.dart';
import '../models/user.dart';

final db = Localstore.instance;

class MainProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

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
    final response = await _apiClient.get('/auth/user');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final user = User(
          id: responseData['data']['id'],
          email: responseData['data']['email'],
          isEmailVerified: responseData['data']['email_verified']
      );
      setUser(user);
      return user;
    } else {
      logout();
      return null;
    }
  }

  Future<String> login(String email, String password) async {
    final response = await _apiClient.post(
      '/auth/token',
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
    final response = await _apiClient.post('/auth/forgot-password', {'email': email});

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> reset_password(String key, String password) async {
    final response = await _apiClient.post('/auth/reset-password', {'code': key, 'password': password});

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> resend_verification_code() async {
    final response = await _apiClient.get('/auth/send_verification_code');

    if (response.statusCode == 200) {
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> verify_email(String key) async {
    final response = await _apiClient.post('/auth/verify_email', {'code': key});

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
          isEmailVerified: true
      );
      setUser(user);
      return '';
    } else {
      return response.body;
    }
  }

  Future<String> register(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/auth/register', data);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      await db.collection('auth').doc('user').set(responseData['data']);
      await db
          .collection('auth')
          .doc('token')
          .set({'token': responseData['token']});
      final user = User(
          id: responseData['data']['id'],
          email: responseData['data']['email'],
          isEmailVerified: responseData['data']['email_verified'],

      );
      setUser(user);
      return '';
    } else {
      return response.body;
    }
  }
}
