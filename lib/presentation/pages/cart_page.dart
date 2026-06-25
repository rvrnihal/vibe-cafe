import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';
import 'package:vibe_cafe/presentation/controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping Cart'),
            centerTitle: true,
          ),
          body: Obx(
            () {
              if (controller.isCartEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: context.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Continue Shopping'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.cartItems[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Item Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: Image.asset(
                                      item.foodImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Center(
                                        child: Text('🍽️', style: TextStyle(fontSize: 32)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Item Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.foodName,
                                        style: context.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.foodPrice.toCurrency(),
                                        style: context.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Subtotal: ${item.subtotal.toCurrency()}',
                                        style: context.textTheme.labelMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Quantity Controls
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => controller.increaseQuantity(index),
                                    ),
                                    Text('${item.quantity}'),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => controller.decreaseQuantity(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Cart Summary
                  _buildCartSummary(context, controller),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCartSummary(BuildContext context, CartController controller) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:', style: context.textTheme.bodyMedium),
                Text(
                  controller.totalPrice.value.toCurrency(),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax (10%):', style: context.textTheme.bodyMedium),
                Text(
                  controller.taxAmount.value.toCurrency(),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery:', style: context.textTheme.bodyMedium),
                Text(
                  controller.deliveryCharge.value.toCurrency(),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  controller.grandTotal.value.toCurrency(),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => Get.toNamed('/payment'),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
