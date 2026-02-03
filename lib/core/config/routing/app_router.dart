import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/pages/register/register_page.dart';
import '../../../features/onboarding/presentation/pages/splash_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/menu/presentation/pages/menu_page.dart';
import '../../../features/cart/presentation/pages/cart_page.dart';
import '../../../features/auth/presentation/pages/login/login_page.dart';
import '../../widgets/navigation/custom_bottom_navigation.dart';
import 'app_routes.dart';

// Router
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      // Route don't have nav bar
      //Onboarding
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      //Auth
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // ShellRoute have nav bar
      ShellRoute(
        builder: (context, state, child) {
          final int currentIndex = _getNavIndex(state.uri.path);
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomBottomNavBar(initialIndex: currentIndex),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.menu,
            builder: (context, state) => const MenuPage(),
          ),
          GoRoute(
            path: AppRoutes.cart,
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );

  static int _getNavIndex(String path) {
    if (path == AppRoutes.menu) return 0;
    if (path.startsWith(AppRoutes.cart)) return 1;
    if (path.startsWith(AppRoutes.profile)) return 2;
    return 0;
  }
}
