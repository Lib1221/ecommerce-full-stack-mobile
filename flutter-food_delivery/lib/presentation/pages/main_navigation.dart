import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'homepage_view.dart';
import 'product_list_view.dart';
import 'cart_view.dart';
import 'profile_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final RxInt _selectedIndex = 0.obs;
  final List<Widget> _pages = [
    HomepageView(),
    ProductListView(),
    CartView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _pages[_selectedIndex.value],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex.value,
            onDestinationSelected: (index) => _selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.grid_view), label: 'Products'),
              NavigationDestination(
                  icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
              NavigationDestination(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
            height: 70,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
        ));
  }
}
