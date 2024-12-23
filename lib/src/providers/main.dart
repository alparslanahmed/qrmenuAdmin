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

  Future<String> login(String email, String password) async {
    final response = await _apiClient.post(
      '/auth/login',
      {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      await db.collection('auth').doc('user').set({
        'id': responseData['user']['id'],
        'email': responseData['user']['email']
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
}
