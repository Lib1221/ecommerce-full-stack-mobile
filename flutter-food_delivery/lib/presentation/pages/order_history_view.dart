import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/api_service.dart';
import 'package:get/get.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  final ApiService _apiService = ApiService();
  late Future<List> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _apiService.fetchOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = _apiService.fetchOrders();
    });
    await _ordersFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'Order History',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true, 
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FutureBuilder<List>(
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.redAccent),
                      const SizedBox(height: 12),
                      Text('Failed to load orders',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('${snapshot.error}',
                          style: GoogleFonts.inter(color: Colors.black54)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _refreshOrders,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No orders found',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                );
              } else if (snapshot.hasData) {
                final orders = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: _refreshOrders,
                  child: ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderId = order['id'] ?? 'N/A';
                      final orderDate = order['created_at'] ?? '';
                      final orderStatus = order['status'] ?? 'Pending';
                      final orderTotal = order['total'] ?? '';
                      return Material(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Get.toNamed('/order-detail', arguments: order);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.receipt_long,
                                    size: 40,
                                    color: theme.iconTheme.color
                                        ?.withOpacity(0.3)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order #$orderId',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Placed on $orderDate',
                                        style: GoogleFonts.inter(
                                          color:
                                              theme.textTheme.bodyMedium?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Status: $orderStatus',
                                        style: GoogleFonts.inter(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total: $orderTotal',
                                        style: GoogleFonts.inter(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right,
                                    color: theme.iconTheme.color),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
