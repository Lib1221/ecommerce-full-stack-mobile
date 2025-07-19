import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/controllers/auth_controller.dart';
import 'package:get_storage/get_storage.dart';
import './modern_app_bar.dart';
import './error_display.dart';
import '../../core/ui_constants.dart';
import './animated_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: ModernAppBar(
          title: 'Login',
          actions: [
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () {},
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPagePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/avatar
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.cardColor,
                  child: Icon(Icons.shopping_bag,
                      size: 48, color: theme.iconTheme.color?.withOpacity(0.7)),
                ),
                SizedBox(height: kSectionSpacing),
                // Welcome text
                Text(
                  'Welcome Back',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: kItemSpacing),
                Text(
                  'Sign in to your account',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: kSectionSpacing),
                // Username field
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon:
                        Icon(Icons.person, color: theme.iconTheme.color),
                  ),
                  style: GoogleFonts.inter(
                      color: theme.textTheme.bodyMedium?.color),
                ),
                SizedBox(height: kItemSpacing),
                // Password field
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                  ),
                  obscureText: true,
                  style: GoogleFonts.inter(
                      color: theme.textTheme.bodyMedium?.color),
                ),
                SizedBox(height: kSectionSpacing),
                // Error message
                Obx(() {
                  if (authController.error.value.isNotEmpty) {
                    return ErrorDisplay(
                      message: authController.error.value,
                      onRetry: () => authController.clearError(),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                // Login button
                SizedBox(
                  height: 54,
                  child: Obx(() => authController.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                              color: theme.primaryColor))
                      : AnimatedButton(
                          onTap: () async {
                            if (usernameController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              await authController.login(
                                usernameController.text,
                                passwordController.text,
                              );
                              // Store username after successful login
                              if (authController.isLoggedIn) {
                                // Use GetStorage for consistency
                                final box = GetStorage();
                                await box.write(
                                    'username', usernameController.text);
                              }
                            } else {
                              Get.snackbar(
                                'Error',
                                'Please fill in all fields',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor:
                                    theme.snackBarTheme.backgroundColor,
                                colorText:
                                    theme.snackBarTheme.contentTextStyle?.color,
                              );
                            }
                          },
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme
                                  .elevatedButtonTheme.style?.backgroundColor
                                  ?.resolve({}),
                              foregroundColor: theme
                                  .elevatedButtonTheme.style?.foregroundColor
                                  ?.resolve({}),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kCardRadius),
                              ),
                              elevation: 0,
                            ),
                            onPressed: null,
                            child: Text(
                              'Login',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme
                                    .elevatedButtonTheme.style?.foregroundColor
                                    ?.resolve({}),
                              ),
                            ),
                          ),
                        )),
                ),
                SizedBox(height: kItemSpacing),
                // Navigation to signup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: GoogleFonts.inter(
                          color: theme.textTheme.titleMedium?.color),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed('/signup'),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.inter(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
