import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibe_cafe/presentation/controllers/auth_controller.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';
import 'package:vibe_cafe/config/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                  ],
          ),
        ),
        child: Obx(
          () {
            if (!authController.isLoggedIn) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 72,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Guest Account',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to order products, manage addresses, and access VIP loyalty rewards.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => Get.toNamed(AppRoutes.login),
                          child: const Text('Sign In Now'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final user = authController.currentUser.value!;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar & Name Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5).withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: context.colorScheme.primary.withOpacity(0.12),
                          child: Text(
                            '👤',
                            style: GoogleFonts.poppins(fontSize: 40),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          user.name,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Wallet & Loyalty Points Card Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5).withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wallet Balance',
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                (user.walletBalance ?? 0.0).toCurrency(),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF34C759),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5).withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loyalty Points',
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${user.loyaltyPoints ?? 0} pts',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Account Details
                  Text(
                    'Account Details',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildProfileField(context, 'Phone Number', user.phone ?? 'Not provided', isDark),
                        _buildProfileField(context, 'Delivery Address', user.address ?? 'Not provided', isDark),
                        _buildProfileField(
                          context, 
                          'Location', 
                          user.city != null ? '${user.city}, ${user.state}' : 'Not provided', 
                          isDark,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Logout Button
                  OutlinedButton(
                    onPressed: () async {
                      await authController.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: isDark ? const Color(0xFFFF3B30).withOpacity(0.6) : const Color(0xFFFF3B30)),
                      foregroundColor: const Color(0xFFFF3B30),
                    ),
                    child: const Text('Logout Account'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileField(BuildContext context, String label, String value, bool isDark, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            value, 
            style: GoogleFonts.inter(
              fontSize: 14, 
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          if (!isLast) ...[
            const SizedBox(height: 12),
            Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF0F0F0), height: 1),
          ],
        ],
      ),
    );
  }
}
