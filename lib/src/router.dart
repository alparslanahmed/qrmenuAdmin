import 'package:go_router/go_router.dart';
import 'package:qr_admin/src/pages/home/home_page.dart';

import 'auth/login_page.dart';
import 'auth/register_page.dart';

// GoRouter configuration
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
  ],
);

