// Order Status Enum
enum OrderStatus {
  pending('Pending', 'Order is being prepared'),
  confirmed('Confirmed', 'Order confirmed by restaurant'),
  preparing('Preparing', 'Chef is preparing your order'),
  readyForPickup('Ready for Pickup', 'Your order is ready'),
  outForDelivery('Out for Delivery', 'Your order is on the way'),
  delivered('Delivered', 'Order delivered successfully'),
  cancelled('Cancelled', 'Order has been cancelled'),
  failed('Failed', 'Order processing failed');

  final String displayName;
  final String description;
  const OrderStatus(this.displayName, this.description);
}

// Payment Status Enum
enum PaymentStatus {
  pending('Pending'),
  processing('Processing'),
  completed('Completed'),
  failed('Failed'),
  refunded('Refunded');

  final String displayName;
  const PaymentStatus(this.displayName);
}

// Payment Method Enum
enum PaymentMethod {
  creditCard('Credit Card'),
  debitCard('Debit Card'),
  upi('UPI'),
  netBanking('Net Banking'),
  googlePay('Google Pay'),
  applePay('Apple Pay'),
  wallet('Wallet'),
  cod('Cash on Delivery');

  final String displayName;
  const PaymentMethod(this.displayName);
}

// Delivery Type Enum
enum DeliveryType {
  delivery('Delivery'),
  pickup('Pickup'),
  dineIn('Dine In');

  final String displayName;
  const DeliveryType(this.displayName);
}

// Reservation Status Enum
enum ReservationStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled');

  final String displayName;
  const ReservationStatus(this.displayName);
}

// User Role Enum
enum UserRole {
  customer('Customer'),
  admin('Admin'),
  vendor('Vendor'),
  deliveryPartner('Delivery Partner');

  final String displayName;
  const UserRole(this.displayName);
}

// Filter Type Enum
enum FilterType {
  rating('Rating'),
  price('Price'),
  deliveryTime('Delivery Time'),
  distance('Distance'),
  popularity('Popularity');

  final String displayName;
  const FilterType(this.displayName);
}

// Sort Type Enum
enum SortType {
  ascending('Ascending'),
  descending('Descending');

  final String displayName;
  const SortType(this.displayName);
}

// Rating Enum
enum Rating {
  one(1, '⭐'),
  two(2, '⭐⭐'),
  three(3, '⭐⭐⭐'),
  four(4, '⭐⭐⭐⭐'),
  five(5, '⭐⭐⭐⭐⭐');

  final int value;
  final String displayValue;
  const Rating(this.value, this.displayValue);
}

// Food Category Enum
enum FoodCategory {
  mainCourse('Main Course'),
  appetizers('Appetizers'),
  desserts('Desserts'),
  beverages('Beverages'),
  snacks('Snacks'),
  vegan('Vegan'),
  glutenFree('Gluten Free');

  final String displayName;
  const FoodCategory(this.displayName);
}

// App State Enum
enum AppState {
  initial,
  loading,
  loaded,
  error,
  empty,
  refreshing,
}
