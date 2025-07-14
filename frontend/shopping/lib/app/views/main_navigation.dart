import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'homepage_view.dart';
import 'product_list_view.dart';
import 'cart_view.dart';
import 'wishlist_view.dart';
import 'profile_view.dart';
import 'order_history_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomepageView(),
    OrderHistoryView(),
    CartView(),
    WishlistView(),
    ProfileView(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.history, label: 'Orders'),
    _NavItem(icon: Icons.shopping_cart, label: 'Cart'),
    _NavItem(icon: Icons.favorite, label: 'Wishlist'),
    _NavItem(icon: Icons.person, label: 'Profile'),
  ];

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: _navItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
