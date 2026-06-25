import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    {'name': 'Credit Card', 'icon': Icons.credit_card_rounded},
    {'name': 'Debit Card', 'icon': Icons.payment_rounded},
    {'name': 'UPI', 'icon': Icons.qr_code_2_rounded},
    {'name': 'Cash on Delivery', 'icon': Icons.local_atm_rounded},
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF34C759), size: 32),
            const SizedBox(width: 10),
            Text(
              'Order Confirmed',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Your order of ${cartController.grandTotal.value.toCurrency()} was successfully placed using $_selectedMethod!',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              cartController.clearCart();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
            child: Text(
              'Back to Home',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5).withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Items Subtotal', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                          Text(cartController.totalPrice.value.toCurrency(), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax (10%)', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                          Text(cartController.taxAmount.value.toCurrency(), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Fee', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                          Text(cartController.deliveryCharge.value.toCurrency(), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            cartController.grandTotal.value.toCurrency(),
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Delivery Details Form
                Text(
                  'Delivery Details',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Delivery Address',
                    hintText: 'Enter your flat number, building and street address',
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: context.colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid delivery address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Payment Method Selectors
                Text(
                  'Payment Method',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    final isSelected = _selectedMethod == method['name'];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? context.colorScheme.primary
                              : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5E5).withOpacity(0.5)),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isSelected ? 0.05 : 0.01),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedMethod = method['name'] as String;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          child: Row(
                            children: [
                              Icon(
                                method['icon'] as IconData,
                                color: isSelected ? context.colorScheme.primary : Colors.grey[500],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  method['name'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected 
                                        ? (isDark ? Colors.white : const Color(0xFF1D1D1F))
                                        : (isDark ? Colors.grey[400] : Colors.grey[700]),
                                  ),
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected 
                                        ? context.colorScheme.primary 
                                        : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected 
                                    ? Center(
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: context.colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Payment Details Form Panel
                if (_selectedMethod == 'Credit Card' || _selectedMethod == 'Debit Card') ...[
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Details',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cardNumberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            prefixIcon: Icon(
                              Icons.credit_card_outlined,
                              color: context.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 16) {
                              return 'Enter a valid 16-digit card number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _expiryController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  labelText: 'Expiry (MM/YY)',
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
                            const SizedBox(width: 14),
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
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Cardholder Name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: context.colorScheme.primary.withOpacity(0.7),
                            ),
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
                ] else if (_selectedMethod == 'UPI') ...[
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UPI Account Details',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _upiController,
                          decoration: InputDecoration(
                            labelText: 'UPI ID / VPA',
                            hintText: 'username@bank',
                            prefixIcon: Icon(
                              Icons.qr_code_2_rounded,
                              color: context.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Enter a valid UPI ID (e.g. user@bank)';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 36),

                ElevatedButton(
                  onPressed: () => _processPayment(cartController),
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  child: const Text('Pay & Complete Order'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
