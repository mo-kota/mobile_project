import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/home_catalog_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/cart_checkout_page.dart';
import 'pages/favorites_page.dart';
import 'pages/order_confirmed_page.dart';
import 'models/product.dart';

class AppRoot extends StatelessWidget {
  final User? authUser;
  const AppRoot({super.key, required this.authUser});

  @override
  Widget build(BuildContext context) {
    return authUser == null ? const LoginPage() : const HomeCatalogPage();
  }
}

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String orderConfirmed = '/order-confirmed';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    signup: (_) => const SignupPage(),
    forgotPassword: (_) => const ForgotPasswordPage(),
    home: (_) => const HomeCatalogPage(),
    cart: (_) => const CartCheckoutPage(),
    favorites: (_) => const FavoritesPage(),
    orderConfirmed: (_) => const OrderConfirmedPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/product-detail') {
      final product = settings.arguments as Product;
      return MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product),
      );
    }
    return null;
  }
}
