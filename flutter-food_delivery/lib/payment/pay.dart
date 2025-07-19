// ignore_for_file: avoid_print

import 'package:check/payment/key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/cart_controller.dart'; // adjust path as needed

class Stripeservice {
  Stripeservice._();
  static final Stripeservice instance = Stripeservice._();

  String? _clientSecret;

  Future<void> makePayment(int money) async {
    try {
      String? result = await createPaymentIntent(money, "usd");
      if (result == null) {
        print("❌ Failed to get client secret");
        return;
      } else {
        _clientSecret = result;

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: result,
            merchantDisplayName: "Liben Adugna",
          ),
        );

        await processpayment();
      }
    } catch (e) {
      print("❌ Error in makePayment: ${e.toString()}");
    }
  }

  Future<String?> createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        print("✅ Created PaymentIntent: ${response.data}");
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print("❌ Error in createPaymentIntent: ${e.toString()}");
    }
    return null;
  }

  Future<void> processpayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // ✅ Check payment intent status
      if (_clientSecret != null) {
        final paymentIntent = await Stripe.instance.retrievePaymentIntent(_clientSecret!);
final status = paymentIntent.status;

print("🎯 PaymentIntent Status: $status");

if (status == PaymentIntentsStatus.Succeeded) {
  print("✅ Payment succeeded!");
  await Get.find<CartController>().checkout();
} else {
  print("⚠️ Payment not successful: $status");
}

}

    } on StripeException catch (e) {
      print("❌ Payment failed: ${e.error.localizedMessage}");
    } catch (e) {
      print("❌ Error in processpayment: ${e.toString()}");
    }
  }

  String calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Stripe expects amount in cents
    return calculatedAmount.toString();
  }
}

Future<void> setup() async {
  Stripe.publishableKey = stripePublishableKey;
}
