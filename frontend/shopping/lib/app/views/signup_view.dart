import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/avatar
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.cardColor,
                  child: Icon(Icons.person_add,
                      size: 48, color: theme.iconTheme.color?.withOpacity(0.7)),
                ),
                const SizedBox(height: 32),
                // Welcome text
                Text(
                  'Create Account',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Join Shop Mobile today!',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                const SizedBox(height: 20),
                // Email field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: theme.iconTheme.color),
                  ),
                  style: GoogleFonts.inter(
                      color: theme.textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                // Confirm Password field
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon:
                        Icon(Icons.lock_outline, color: theme.iconTheme.color),
                  ),
                  obscureText: true,
                  style: GoogleFonts.inter(
                      color: theme.textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 24),
                // Error message
                Obx(() {
                  if (authController.error.value.isNotEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: theme.iconTheme.color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authController.error.value,
                              style: GoogleFonts.inter(
                                  color: theme.textTheme.bodyMedium?.color),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                // Signup button
                SizedBox(
                  height: 54,
                  child: Obx(() => authController.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                              color: theme.primaryColor))
                      : ElevatedButton(
                          onPressed: () {
                            if (usernameController.text.isNotEmpty &&
                                emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty &&
                                confirmPasswordController.text.isNotEmpty) {
                              if (passwordController.text ==
                                  confirmPasswordController.text) {
                                authController.signup(
                                  usernameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Passwords do not match',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor:
                                      theme.snackBarTheme.backgroundColor,
                                  colorText: theme
                                      .snackBarTheme.contentTextStyle?.color,
                                );
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme
                                .elevatedButtonTheme.style?.backgroundColor
                                ?.resolve({}),
                            foregroundColor: theme
                                .elevatedButtonTheme.style?.foregroundColor
                                ?.resolve({}),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme
                                  .elevatedButtonTheme.style?.foregroundColor
                                  ?.resolve({}),
                            ),
                          ),
                        )),
                ),
                const SizedBox(height: 20),
                // Navigation to login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.inter(
                          color: theme.textTheme.titleMedium?.color),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed('/login'),
                      child: Text(
                        'Login',
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
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
