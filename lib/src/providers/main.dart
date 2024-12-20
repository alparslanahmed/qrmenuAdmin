import 'package:flutter/material.dart';
import '../models/user.dart';

class MainProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool isAuthenticated() {
    return _user != null;
  }
}