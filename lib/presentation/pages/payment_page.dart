import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibe_cafe/core/utils/extensions.dart';
import 'package:vibe_cafe/presentation/controllers/cart_controller.dart';
import 'package:vibe_cafe/config/app_routes.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedMethod = 'Credit Card';
  
  // Controllers
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  final _upiController = TextEditingController();
  final _addressController = TextEditingController();

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Credit Card', 'icon': Icons.credit_card},
    {'name': 'Debit Card', 'icon': Icons.payment},
    {'name': 'UPI', 'icon': Icons.phone_android},
    {'name': 'Cash on Delivery', 'icon': Icons.local_atm},
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _upiController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _processPayment(CartController cartController) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show simulated success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text(
          'Your order of ${cartController.grandTotal.value.toCurrency()} was successfully placed using $_selectedMethod!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              cartController.clearCart();
              Get.offAllNamed(AppRoutes.home);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Payment'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Order Summary Card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Items total:', style: context.textTheme.bodyMedium),
                          Text(cartController.totalPrice.value.toCurrency(), style: context.textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax (10%):', style: context.textTheme.bodyMedium),
                          Text(cartController.taxAmount.value.toCurrency(), style: context.textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery fee:', style: context.textTheme.bodyMedium),
                          Text(cartController.deliveryCharge.value.toCurrency(), style: context.textTheme.bodyMedium),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total:',
                            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            cartController.grandTotal.value.toCurrency(),
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Delivery Address Form
              Text(
                'Delivery Details',
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Delivery Address',
                  hintText: 'Enter your flat/street address',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid delivery address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Payment Method Selectors
              Text(
                'Payment Method',
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  final isSelected = _selectedMethod == method['name'];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isSelected
                          ? BorderSide(color: context.colorScheme.primary, width: 2)
                          : BorderSide.none,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(
                        method['icon'],
                        color: isSelected ? context.colorScheme.primary : Colors.grey,
                      ),
                      title: Text(
                        method['name'],
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: Radio<String>(
                        value: method['name'],
                        groupValue: _selectedMethod,
                        onChanged: (val) {
                          setState(() {
                            _selectedMethod = val!;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Payment details inputs based on selection
              if (_selectedMethod == 'Credit Card' || _selectedMethod == 'Debit Card') ...[
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Card details',
                          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _cardNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Card Number',
                            prefixIcon: Icon(Icons.credit_card_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 16) {
                              return 'Enter a valid 16-digit card number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _expiryController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  labelText: 'Expiry Date (MM/YY)',
                                  hintText: 'MM/YY',
                                ),
                                validator: (value) {
                                  if (value == null || !value.contains('/')) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'CVV',
                                  hintText: '123',
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 3) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Cardholder Name',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter cardholder name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (_selectedMethod == 'UPI') ...[
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'UPI details',
                          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _upiController,
                          decoration: const InputDecoration(
                            labelText: 'UPI ID',
                            hintText: 'username@bank',
                            prefixIcon: Icon(Icons.qr_code_2),
                          ),
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Enter a valid UPI ID (e.g. user@ybl)';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () => _processPayment(cartController),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Pay & Complete Order',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
