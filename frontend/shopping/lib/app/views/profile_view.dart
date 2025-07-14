import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../../theme.dart';

class ProfileView extends StatefulWidget {
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
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          centerTitle: true,
          actions: [
            Obx(() => IconButton(
                  icon: Icon(
                    themeController.isDarkMode.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: theme.iconTheme.color,
                  ),
                  tooltip: themeController.isDarkMode.value
                      ? 'Switch to Day Mode'
                      : 'Switch to Night Mode',
                  onPressed: () => themeController.toggleTheme(),
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : error.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 40),
                          const SizedBox(height: 12),
                          Text('Failed to load profile',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          const SizedBox(height: 8),
                          Text(error,
                              style: GoogleFonts.inter(
                                  color: theme.textTheme.bodyMedium?.color)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchProfile,
                            child: Text('Retry',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: theme.cardColor,
                          child: Icon(Icons.person,
                              size: 48,
                              color: theme.iconTheme.color?.withOpacity(0.7)),
                        ),
                        const SizedBox(height: 24),
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
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            profile?['email'] ?? '-',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: theme.iconTheme.color),
                                  const SizedBox(width: 12),
                                  Text('Account',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: theme.textTheme.bodyLarge?.color,
                                      )),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      color: theme.iconTheme.color, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    profile?['date_joined'] != null
                                        ? 'Joined: ' +
                                            profile!['date_joined']
                                                .toString()
                                                .split('T')
                                                .first
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
                        const SizedBox(height: 36),
                        // Modern action buttons
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: Obx(() {
                            final isDark = themeController.isDarkMode.value;
                            return ElevatedButton(
                              onPressed: () => Get.toNamed('/orders'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isDark ? Colors.white : Colors.black,
                                foregroundColor:
                                    isDark ? Colors.black : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
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
                                  const SizedBox(width: 10),
                                  Text('View Orders'),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 18),
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
                                borderRadius: BorderRadius.circular(18),
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
                                const SizedBox(width: 10),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
        ),
      ),
    );
  }
}
