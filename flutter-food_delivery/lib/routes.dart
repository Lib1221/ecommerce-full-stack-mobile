// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';
import '../presentation/pages/login_view.dart';
import '../presentation/pages/signup_view.dart';
import '../presentation/pages/profile_view.dart';
import '../presentation/pages/order_history_view.dart';
import '../presentation/pages/product_details_view.dart';
import 'presentation/pages/main_navigation.dart';
import 'presentation/pages/product_list_view.dart';
import 'presentation/pages/wishlist_view.dart';
import '../presentation/pages/cartview/cart_view.dart';

class Routes {
  static const MAIN_NAV = '/main-nav';
  static const PRODUCTS = '/products';
  static const CART = '/cart';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const AMAZING = '/amazing';
  static const PROFILE = '/profile';
  static const WISHLIST = '/wishlist';
  static const ORDERS = '/orders';
  static const PRODUCT_DETAILS = '/product-details';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.MAIN_NAV, page: () => MainNavigation()),
    GetPage(name: Routes.PRODUCTS, page: () => ProductListView()),
    GetPage(name: Routes.CART, page: () => CartView()),
    GetPage(name: Routes.LOGIN, page: () => LoginView()),
    GetPage(name: Routes.SIGNUP, page: () => SignupView()),
    GetPage(name: Routes.PROFILE, page: () => ProfileView()),
    GetPage(name: Routes.WISHLIST, page: () => WishlistView()),
    GetPage(name: Routes.ORDERS, page: () => OrderHistoryView()),
    GetPage(
        name: Routes.PRODUCT_DETAILS,
        page: () => ProductDetailsView(product: const {})),
  ];
}
