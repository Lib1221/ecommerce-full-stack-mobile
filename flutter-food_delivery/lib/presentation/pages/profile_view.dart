import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/theme_controller.dart';
import './modern_app_bar.dart';
import './error_display.dart';
import '../../core/ui_constants.dart';
import './cart_icon_with_badge.dart';
import './order_history_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  Map<String, dynamic>? profile;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final data = await authController.api.getUserProfile();
      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: ModernAppBar(
          title: 'Profile',
          actions: [
            CartIconWithBadge(onTap: () => Get.toNamed('/cart')),
            Obx(() {
              final isDark = themeController.isDarkMode.value;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: isDark ? 'Switch to Day Mode' : 'Switch to Night Mode',
                onPressed: () => themeController.toggleTheme(),
              );
            }),
            IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(kPagePadding),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : error.isNotEmpty
                  ? ErrorDisplay(
                      message:
                          'Failed to load profile. Please check your connection and try again.',
                      onRetry: _fetchProfile,
                    )
                  : ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        SizedBox(height: kItemSpacing),
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: theme.cardColor,
                          child: Icon(Icons.person,
                              size: 48,
                              color: theme.iconTheme.color?.withOpacity(0.7)),
                        ),
                        SizedBox(height: kItemSpacing),
                        Center(
                          child: Text(
                            profile?['username'] ?? '-',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                        ),
                        SizedBox(height: kItemSpacing),
                        Center(
                          child: Text(
                            profile?['email'] ?? '-',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                        SizedBox(height: kSectionSpacing),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(kCardPadding),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(kCardRadius),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: theme.iconTheme.color),
                                  SizedBox(width: kItemSpacing),
                                  Text('Account',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: theme.textTheme.bodyLarge?.color,
                                      )),
                                ],
                              ),
                              SizedBox(height: kItemSpacing),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: theme.iconTheme.color, size: 20),
                                  SizedBox(width: kItemSpacing),
                                  Text(
                                    profile?['date_joined'] != null
                                        ? 'Joined: ${profile!['date_joined'].toString().split('T').first}'
                                        : 'Joined: -',
                                    style: GoogleFonts.inter(
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: kSectionSpacing),
                        // Modern action buttons
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: Obx(() {
                            final isDark = themeController.isDarkMode.value;
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => OrderHistoryView()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isDark ? Colors.white : Colors.black,
                                foregroundColor:
                                    isDark ? Colors.black : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(kCardRadius),
                                  side: BorderSide(
                                    color: isDark ? Colors.white : Colors.black,
                                    width: 2,
                                  ),
                                ),
                                textStyle: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.receipt_long, size: 24),
                                  SizedBox(width: kItemSpacing),
                                  Text('View Orders'),
                                ],
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: kItemSpacing),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () async {
                              await authController.logout();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kCardRadius),
                              ),
                              textStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, size: 24),
                                SizedBox(width: kItemSpacing),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: kSectionSpacing),
                      ],
                    ),
        ),
      ),
    );
  }
}
