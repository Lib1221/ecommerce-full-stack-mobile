import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/controllers/auth_controller.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/ui_constants.dart';
import './error_display.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🖼️ Background image from Unsplash (free)
          Image.network(
            'https://images.unsplash.com/photo-1606813902917-95d6c0dc01f4?auto=format&fit=crop&w=934&q=80',
            fit: BoxFit.cover,
          ),

          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Login Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(kCardRadius * 2),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        'Welcome Back!',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: kItemSpacing),
                      Text(
                        'Login to your Shop account',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: kSectionSpacing),

                      // Username
                      TextFormField(
                        controller: usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Username', Icons.person),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter username' : null,
                      ),
                      const SizedBox(height: kItemSpacing),

                      // Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Password', Icons.lock),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter password' : null,
                      ),

                      const SizedBox(height: kSectionSpacing),

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

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Obx(() => authController.isLoading.value
                            ? const Center(child: CircularProgressIndicator(color: Colors.white))
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(kCardRadius),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    await authController.login(
                                      usernameController.text,
                                      passwordController.text,
                                    );
                                    if (authController.isLoggedIn) {
                                      final box = GetStorage();
                                      await box.write('username', usernameController.text);
                                    }
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Please fill in all fields',
                                      backgroundColor: Colors.redAccent,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                      ),
                      const SizedBox(height: kItemSpacing),

                      // Sign Up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: GoogleFonts.inter(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => Get.offAllNamed('/signup'),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
        borderSide: const BorderSide(color: Colors.white),
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
