import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/product_controller.dart';
import 'app/controllers/cart_controller.dart';
import 'app/controllers/wishlist_controller.dart';
import 'app/controllers/theme_controller.dart';

void main() async {
  await GetStorage.init();

  // Initialize controllers
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(WishlistController());
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');
    final initialRoute = token != null ? Routes.MAIN_NAV : Routes.LOGIN;
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          title: 'Shop Mobile',
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




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Stripe.publishableKey = 'pk_test_51QCqhAIn212ReFWzcVspm505bU1fbSLo2WamdHn2Vv9ocOeZYXBCq6FaMrT2Gx6dUVrH5bUr9nUShkzEhltZ80Ey00Az5MELVV'; // Your publishable key
//   await Stripe.instance.applySettings();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Stripe Payment Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const PaymentScreen(),
//     );
//   }
// }

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   bool _loading = false;

//   Future<String?> createPaymentIntent(int amountInCents) async {
//     final url = Uri.parse('http://10.0.2.2:8000/shop/create-payment-intent/');
//     final headers = {'Content-Type': 'application/json'};
//     final body = json.encode({'amount': amountInCents});

//     try {
//       final response = await http.post(url, headers: headers, body: body);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['clientSecret'];
//       } else {
//         print('Error: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Exception: $e');
//       return null;
//     }
//   }

//   Future<void> makePayment() async {
//     setState(() => _loading = true);

//     final clientSecret = await createPaymentIntent(1000); // $10.00
//     if (clientSecret == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to create PaymentIntent')),
//       );
//       setState(() => _loading = false);
//       return;
//     }

//     try {
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: clientSecret,
//           merchantDisplayName: 'My Flutter Store',
//           style: ThemeMode.light,
//         ),
//       );

//       await Stripe.instance.presentPaymentSheet();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Payment successful')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Payment failed: $e')),
//       );
//     }

//     setState(() => _loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Stripe Payment')),
//       body: Center(
//         child: _loading
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//                 onPressed: makePayment,
//                 child: const Text('Pay \$10.00'),
//               ),
//       ),
//     );
//   }
// }
