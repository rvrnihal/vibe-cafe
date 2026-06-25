import 'package:get/get.dart';
import 'package:vibe_cafe/presentation/pages/cart_page.dart';
import 'package:vibe_cafe/presentation/pages/home_page.dart';
import 'package:vibe_cafe/presentation/pages/login_page.dart';
import 'package:vibe_cafe/presentation/pages/menu_page.dart';
import 'package:vibe_cafe/presentation/pages/orders_page.dart';
import 'package:vibe_cafe/presentation/pages/payment_page.dart';
import 'package:vibe_cafe/presentation/pages/profile_page.dart';
import 'package:vibe_cafe/presentation/pages/register_page.dart';
import 'package:vibe_cafe/presentation/pages/reservation_page.dart';
import 'package:vibe_cafe/presentation/pages/settings_page.dart';
import 'package:vibe_cafe/presentation/pages/splash_page.dart';
import 'package:vibe_cafe/presentation/pages/support_page.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String menu = '/menu';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String orders = '/orders';
  static const String reservation = '/reservation';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String support = '/support';

  // Get pages
  static List<GetPage> getPages = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: register,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: menu,
      page: () => const MenuPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: cart,
      page: () => const CartPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: payment,
      page: () => const PaymentPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: orders,
      page: () => const OrdersPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: reservation,
      page: () => const ReservationPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profile,
      page: () => const ProfilePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: support,
      page: () => const SupportPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
