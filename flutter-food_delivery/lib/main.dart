import 'package:check/payment/key.dart';
import 'package:check/presentation/controllers/auth_controller.dart';
import 'package:check/presentation/controllers/cart_controller.dart';
import 'package:check/presentation/controllers/product_controller.dart';
import 'package:check/presentation/controllers/theme_controller.dart';
import 'package:check/presentation/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:check/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await GetStorage.init();

  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(WishlistController());
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');
    final initialRoute = token != null ? Routes.MAIN_NAV : Routes.LOGIN;
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          title: 'Shop',
          initialRoute: initialRoute,
          getPages: AppPages.pages,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          themeMode: themeController.theme,
        ));
  }
}
