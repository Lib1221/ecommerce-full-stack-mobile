import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/ui_constants.dart';

class CartSummary extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
  final TextEditingController couponController;
  const CartSummary(
      {super.key,
      required this.totalItems,
      required this.totalPrice,
      required this.couponController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  // UI only, no backend logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Coupon applied (UI only)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kCardRadius)),
                ),
                child: Text('Apply'),
              ),
            ],
          ),
          SizedBox(height: kItemSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Items:', style: GoogleFonts.inter(fontSize: 16)),
              Text('$totalItems',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          SizedBox(height: kItemSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Price:',
                  style: GoogleFonts.inter(
                      fontSize: 18, color: theme.primaryColor)),
              Text(' ${totalPrice.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: theme.primaryColor)),
            ],
          ),
          SizedBox(height: kItemSpacing),
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                // UI only, no backend logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Checkout (UI only)')),
                );
              },
              icon: Icon(Icons.payment),
              label: Text('Checkout',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kCardRadius)),
                elevation: 2,
                padding: EdgeInsets.symmetric(vertical: kItemSpacing),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
