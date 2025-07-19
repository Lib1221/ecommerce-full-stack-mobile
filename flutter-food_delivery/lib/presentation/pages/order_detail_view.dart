import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final order = Get.arguments as Map<String, dynamic>?;
    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: const Center(child: Text('No order data found.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order['id'] ?? ''}'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['id'] ?? ''}',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 12),
            Text('Placed on: ${order['created_at'] ?? ''}',
                style: GoogleFonts.inter(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: ${order['status'] ?? 'Pending'}',
                style: GoogleFonts.inter(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Total: ${order['total'] ?? ''}',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.green)),
            // Add more order details here as needed
          ],
        ),
      ),
    );
  }
}
