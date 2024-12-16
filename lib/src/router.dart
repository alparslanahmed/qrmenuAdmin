import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_admin/src/pages/home/home_page.dart';
import 'package:qr_admin/src/providers/main.dart';

import 'auth/login_page.dart';
import 'auth/register_page.dart';

// GoRouter configuration
final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    // Check authentication status from the user property
    final isAuthenticated = mainProvider.user != null;
    if (!isAuthenticated && state.matchedLocation != '/login' && state.matchedLocation != '/register') {
      return '/login';
    } else {
      return null;
    }
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
  ],
);
