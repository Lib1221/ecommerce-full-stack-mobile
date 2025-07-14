import 'package:flutter/material.dart';
import 'homepage_view.dart';
import 'product_list_view.dart';
import 'cart_view.dart';
import 'wishlist_view.dart';
import 'profile_view.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomepageView(),
    ProductListView(),
    CartView(),
    WishlistView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedBg = isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.black.withOpacity(0.07);
    final selectedColor = theme.primaryColor;
    final unselectedColor = theme.iconTheme.color?.withOpacity(0.6);
    final icons = [
      Icons.home,
      Icons.grid_view,
      Icons.shopping_cart,
      Icons.favorite_border,
      Icons.person,
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: _pages[_selectedIndex],
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                height: 68,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(icons.length, (index) {
                    final selected = _selectedIndex == index;
                    return GestureDetector(
                      onTap: () => _onItemTapped(index),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: selected
                            ? BoxDecoration(
                                color: selectedBg,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: Icon(
                          icons[index],
                          size: selected ? 34 : 26,
                          color: selected ? selectedColor : unselectedColor,
                          weight: selected ? 800 : 400,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
