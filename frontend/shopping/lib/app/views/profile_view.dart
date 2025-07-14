import 'package:flutter/material.dart';
import '../controllers/theme_controller.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();

    return FutureBuilder<Map<String, dynamic>>(
      future: authController.api.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data ?? {};
        return Scaffold(
          backgroundColor: const Color(0xFFF6F8FB),
          appBar: AppBar(
            title: const Text('Profile',
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.deepPurple,
            elevation: 0,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: const Icon(Icons.person,
                        size: 48, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    user['username'] ?? 'Username',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user['email'] ?? 'Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 160,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.dark_mode, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      const Text('Dark Mode',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Obx(() => Switch(
                            value: themeController.isDarkMode.value,
                            onChanged: (val) => themeController.toggleTheme(),
                            activeColor: Colors.deepPurple,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
