import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/cart_controller.dart';

class CartIconWithBadge extends StatefulWidget {
  final VoidCallback? onTap;
  const CartIconWithBadge({super.key, this.onTap});

  @override
  State<CartIconWithBadge> createState() => _CartIconWithBadgeState();
}

class _CartIconWithBadgeState extends State<CartIconWithBadge>
    with SingleTickerProviderStateMixin {
  final CartController cartController = Get.find<CartController>();
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  int _lastCount = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    ever(cartController.items, (_) {
      final count = cartController.totalItems;
      if (count > _lastCount) {
        _controller.forward(from: 0).then((_) => _controller.reverse());
      }
      _lastCount = count;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 28),
          Positioned(
            right: -4,
            top: -4,
            child: Obx(() {
              final count = cartController.totalItems;
              if (count == 0) return SizedBox.shrink();
              return ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
