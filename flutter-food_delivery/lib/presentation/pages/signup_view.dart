import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../core/ui_constants.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=934&q=80',
            fit: BoxFit.cover,
          ),

          // Dark overlay
          Container(color: Colors.black.withOpacity(0.6)),

          // Signup form
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
                      color: Colors.black.withOpacity(0.3),
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
                        'Create Account',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: kItemSpacing),
                      Text(
                        'Join Shop Mobile today!',
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
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter username'
                            : null,
                      ),
                      const SizedBox(height: kItemSpacing),

                      // Email
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Email', Icons.email),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter email'
                            : null,
                      ),
                      const SizedBox(height: kItemSpacing),

                      // Password
                      TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: _inputDecoration('Password', Icons.lock),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter password'
                            : null,
                      ),
                      const SizedBox(height: kItemSpacing),

                      // Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: _inputDecoration(
                            'Confirm Password', Icons.lock_outline),
                        validator: (value) => value != passwordController.text
                            ? 'Passwords do not match'
                            : null,
                      ),

                      const SizedBox(height: kSectionSpacing),

                      // Error message
                      Obx(() {
                        if (authController.error.value.isNotEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(kCardPadding),
                            margin: const EdgeInsets.only(bottom: kItemSpacing),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(kCardRadius),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.redAccent),
                                const SizedBox(width: kItemSpacing),
                                Expanded(
                                  child: Text(
                                    authController.error.value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      // Sign up button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Obx(() => authController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.2),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(kCardRadius),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    authController.signup(
                                      usernameController.text,
                                      emailController.text,
                                      passwordController.text,
                                    );
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
                                  'Sign Up',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                      ),
                      const SizedBox(height: kItemSpacing),

                      // Already have an account?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.inter(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => Get.offAllNamed('/login'),
                            child: Text(
                              'Login',
                              style: GoogleFonts.inter(
                                color: Colors.white,
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
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
