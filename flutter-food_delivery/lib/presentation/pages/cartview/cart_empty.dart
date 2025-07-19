import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/ui_constants.dart';
import '../animated_button.dart';

class CartEmpty extends StatelessWidget {
  const CartEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100, color: theme.primaryColor.withOpacity(0.15)),
          SizedBox(height: kSectionSpacing),
          Text('Your cart is empty',
              style:
                  GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: kItemSpacing),
          Text('Looks like you haven\'t added anything yet.',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.6))),
          SizedBox(height: kSectionSpacing),
          AnimatedButton(
            onTap: () => Get.offAllNamed('/products'),
            child: ElevatedButton.icon(
              icon: Icon(Icons.storefront),
              label: Text('Shop Now',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kCardRadius)),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                textStyle: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
