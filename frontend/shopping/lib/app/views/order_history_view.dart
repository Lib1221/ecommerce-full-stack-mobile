import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class OrderController extends GetxController {
  var orders = [].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  final api = ApiService();

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      error.value = '';
      orders.value = await api.fetchOrders();
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}

class OrderHistoryView extends StatelessWidget {
  OrderHistoryView({Key? key}) : super(key: key);
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Order History',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderController.error.isNotEmpty) {
          return Center(
              child: Text('Error: ${orderController.error.value}',
                  style: TextStyle(color: Colors.red)));
        }
        if (orderController.orders.isEmpty) {
          return const Center(
              child: Text('No orders yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            final order = orderController.orders[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order #${order['id']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(order['created_at']?.toString() ?? '',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Total: ${order['total_price']}',
                        style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Products:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...List.generate(
                      (order['items'] as List).length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2),
                        child: Text(
                            '- ${(order['items'] as List)[i]['product_name']}'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
