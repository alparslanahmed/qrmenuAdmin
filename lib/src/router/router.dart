import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstore/localstore.dart';
import 'package:provider/provider.dart';
import 'package:qr_admin/src/auth/forgot_password.dart';
import 'package:qr_admin/src/layouts/tabs_layout.dart';
import 'package:qr_admin/src/pages/home/home_page.dart';
import 'package:qr_admin/src/pages/profile/profile_page.dart';
import 'package:qr_admin/src/pages/settings/settings_page.dart';
import 'package:qr_admin/src/providers/main.dart';

import '../auth/login_page.dart';
import '../auth/password_reset.dart';
import '../auth/register_page.dart';
import '../models/user.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final db = Localstore.instance;

// GoRouter configuration
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/settings',
  redirect: (BuildContext context, GoRouterState state) async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    await db.collection('auth').doc('user').get().then((value) {
      if (value != null) {
        final user = User(id: value['id'], email: value['email'], isEmailVerified: value['email_verified']);
        mainProvider.setUser(user);
      }
    });

    // Check authentication status from the user property
    final isAuthenticated = mainProvider.user != null;

    if (!isAuthenticated &&
        state.matchedLocation != '/login' &&
        state.matchedLocation != '/register' && state.matchedLocation != '/forgot-password' && state.matchedLocation != '/password-reset') {
      return '/login';
    } else {
      return null;
    }
  },
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return TabsLayout(
          child: child,
          state: state,
        );
      },
      routes: [
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfilePage(),
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
    GoRoute(path: '/forgot-password', builder: (context, state) => ForgotPassword()),
    GoRoute(path: '/password-reset', builder: (context, state) => PasswordReset(state: state,)),
  ],
);
