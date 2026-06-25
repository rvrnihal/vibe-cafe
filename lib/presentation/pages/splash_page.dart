import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_cafe/config/app_routes.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToHome();
  }

  void _initializeAnimations() {
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeIn),
    );

    _scaleAnimationController.forward();
    _fadeAnimationController.forward();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with animation
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '🍜',
                    style: context.textTheme.displayLarge,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // App name with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'VIBE CAFE',
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Taste the Vibe',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            // Loading indicator
            FadeTransition(
              opacity: _fadeAnimation,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colorScheme.primary,
                ),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
