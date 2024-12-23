import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstore/localstore.dart';
import 'package:provider/provider.dart';
import 'package:qr_admin/src/layouts/tabs_layout.dart';
import 'package:qr_admin/src/pages/home/home_page.dart';
import 'package:qr_admin/src/pages/profile/profile_page.dart';
import 'package:qr_admin/src/pages/settings/settings_page.dart';
import 'package:qr_admin/src/providers/main.dart';

import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../models/user.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final db = Localstore.instance;

// GoRouter configuration
final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    await db.collection('auth').doc('user').get().then((value) {
      if (value != null) {
        final user = User(id: value['id'], email: value['email']);
        mainProvider.setUser(user);
      }
    });

    // Check authentication status from the user property
    final isAuthenticated = mainProvider.user != null;

    if (!isAuthenticated &&
        state.matchedLocation != '/login' &&
        state.matchedLocation != '/register') {
      return '/login';
    } else {
      return null;
    }
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return TabsLayout(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) =>
                  SettingsPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'settings/:param',
                  builder: (BuildContext context, GoRouterState state) =>
                      SettingsPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _rootNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) =>
                  HomePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'details',
                  builder: (BuildContext context, GoRouterState state) =>
                      HomePage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              builder: (BuildContext context, GoRouterState state) =>
                  ProfilePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'profiledetails',
                  builder: (BuildContext context, GoRouterState state) =>
                      ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
  ],
);
