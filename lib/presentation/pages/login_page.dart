import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_cafe/config/app_routes.dart';
import 'package:vibe_cafe/presentation/controllers/auth_controller.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AuthController authController) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await authController.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      }
    } else {
      Get.snackbar(
        'Login Failed',
        authController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: context.colorScheme.error.withOpacity(0.9),
        colorText: Colors.white,
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
                ? [
                    const Color(0xFF1E1C1A),
                    const Color(0xFF121212),
                  ]
                : [
                    const Color(0xFFFFFDFB),
                    const Color(0xFFFFF9F5),
                    const Color(0xFFF5E6D3).withOpacity(0.3),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E).withOpacity(0.8) : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Coffee Cup Logo
                      Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: context.colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Text(
                              '☕',
                              style: TextStyle(fontSize: 48),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: context.colorScheme.primaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Log in to taste the premium vibes',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: context.colorScheme.primary.withOpacity(0.7),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || !value.isValidEmail()) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: context.colorScheme.primary.withOpacity(0.7),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey[500],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Hint Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: context.colorScheme.tertiary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: context.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Demo: admin@vibe.com / password123',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.primaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Login Button
                      Obx(
                        () => authController.isLoading.value
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () => _handleLogin(authController),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  shadowColor: context.colorScheme.primary.withOpacity(0.25),
                                ),
                                child: const Text('Sign In'),
                              ),
                      ),
                      const SizedBox(height: 24),

                      // Navigation to Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: isDark ? Colors.grey[400] : Colors.grey[700],
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.register),
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
