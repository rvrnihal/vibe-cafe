import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibe_cafe/config/app_routes.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';
import 'package:vibe_cafe/presentation/controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<CartController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Shopping Cart',
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
                if (controller.isCartEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '🛒',
                            style: TextStyle(fontSize: 64),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your cart is empty',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add items from the menu to start order.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Add Items'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Cart Items List
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = controller.cartItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5).withOpacity(0.5),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Item Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    color: isDark ? const Color(0xFF252528) : const Color(0xFFF7ECE1).withOpacity(0.4),
                                    child: Image.asset(
                                      item.foodImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Center(
                                        child: Text('☕', style: TextStyle(fontSize: 28)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // Item Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.foodName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.foodPrice.toCurrency(),
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.grey[550],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.subtotal.toCurrency(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Horizontal Quantity controls
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF2C2C2E) : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_rounded, size: 18),
                                        onPressed: () => controller.decreaseQuantity(index),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(6),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Text(
                                          '${item.quantity}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_rounded, size: 18),
                                        onPressed: () => controller.increaseQuantity(index),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(6),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Cart Summary Sheet
                    _buildCartSummary(context, controller),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartSummary(BuildContext context, CartController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal', 
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w500),
                  ),
                  Text(
                    controller.totalPrice.value.toCurrency(),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax (10%)', 
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w500),
                  ),
                  Text(
                    controller.taxAmount.value.toCurrency(),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Charge', 
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w500),
                  ),
                  Text(
                    controller.deliveryCharge.value.toCurrency(),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                  Text(
                    controller.grandTotal.value.toCurrency(),
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.payment),
                child: const Text('Proceed to Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
