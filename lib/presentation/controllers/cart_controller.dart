import 'package:get/get.dart';
import 'package:vibe_cafe/core/constants/app_constants.dart';
import 'package:vibe_cafe/data/models/cart_item_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble totalPrice = 0.0.obs;
  final RxDouble taxAmount = 0.0.obs;
  final RxDouble deliveryCharge = AppConstants.deliveryChargeBase.obs;
  final RxDouble grandTotal = 0.0.obs;
  final RxDouble discount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(cartItems, (_) => _calculateTotals());
    ever(deliveryCharge, (_) => _calculateTotals());
    ever(discount, (_) => _calculateTotals());
  }

  // Add item to cart
  void addItemToCart({
    required String foodItemId,
    required String foodName,
    required String foodImage,
    required double foodPrice,
    String? selectedFlavor,
    List<String>? selectedCustomizations,
    String? specialInstructions,
  }) {
    final cartItemId = '${foodItemId}_${DateTime.now().millisecondsSinceEpoch}';

    // Check if item already exists with same customizations
    final existingItemIndex = cartItems.indexWhere(
      (item) =>
          item.foodItemId == foodItemId &&
          item.selectedFlavor == selectedFlavor &&
          _listsEqual(item.selectedCustomizations, selectedCustomizations ?? []),
    );

    if (existingItemIndex != -1) {
      // Increase quantity
      increaseQuantity(existingItemIndex);
    } else {
      // Add new item
      final newItem = CartItem(
        id: cartItemId,
        foodItemId: foodItemId,
        foodName: foodName,
        foodImage: foodImage,
        foodPrice: foodPrice,
        quantity: 1,
        selectedFlavor: selectedFlavor,
        selectedCustomizations: selectedCustomizations ?? [],
        specialInstructions: specialInstructions,
        addedAt: DateTime.now(),
      );

      cartItems.add(newItem);
    }

    Get.snackbar('Success', '$foodName added to cart',
        snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
  }

  // Remove item from cart
  void removeItemFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      Get.snackbar('Removed', 'Item removed from cart',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Increase quantity
  void increaseQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    }
  }

  // Decrease quantity
  void decreaseQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      if (item.quantity > 1) {
        cartItems[index] = item.copyWith(quantity: item.quantity - 1);
      } else {
        removeItemFromCart(index);
      }
    }
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
    Get.snackbar('Cleared', 'Cart cleared',
        snackPosition: SnackPosition.BOTTOM);
  }

  // Set delivery charge
  void setDeliveryCharge(double charge) {
    deliveryCharge.value = charge;
  }

  // Set discount
  void setDiscount(double amount) {
    discount.value = amount;
  }

  // Calculate totals
  void _calculateTotals() {
    // Calculate subtotal
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item.subtotal;
    }

    totalPrice.value = subtotal;

    // Calculate tax
    taxAmount.value = subtotal * AppConstants.taxPercentage;

    // Calculate grand total
    grandTotal.value = totalPrice.value + taxAmount.value + deliveryCharge.value - discount.value;

    if (grandTotal.value < 0) {
      grandTotal.value = 0;
    }
  }

  // Get cart summary
  Map<String, dynamic> getCartSummary() {
    return {
      'itemCount': cartItems.length,
      'totalItems': cartItems.fold<int>(0, (sum, item) => sum + item.quantity),
      'subtotal': totalPrice.value,
      'tax': taxAmount.value,
      'deliveryCharge': deliveryCharge.value,
      'discount': discount.value,
      'grandTotal': grandTotal.value,
    };
  }

  // Check if cart is empty
  bool get isCartEmpty => cartItems.isEmpty;

  // Check if cart has items
  bool get hasItems => cartItems.isNotEmpty;

  // Get total items count
  int get totalItemsCount =>
      cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

  // Get cart item at index
  CartItem? getCartItemAt(int index) {
    if (index >= 0 && index < cartItems.length) {
      return cartItems[index];
    }
    return null;
  }

  // Helper method to compare lists
  bool _listsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
