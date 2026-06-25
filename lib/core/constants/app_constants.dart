// App Constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.vibecafe.com/v1';
  static const int apiTimeout = 30; // seconds

  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String animationsPath = 'assets/animations/';
  static const String iconsPath = 'assets/icons/';

  // Tax & Fees
  static const double taxPercentage = 0.1; // 10%
  static const double deliveryChargeBase = 50.0; // ₹50

  // Pagination
  static const int pageSize = 20;

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Cache Duration
  static const cacheDurationMinutes = 30;
}

// Error Messages
class ErrorMessages {
  static const String networkError = 'Network error occurred. Please check your internet connection.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String unauthorizedError = 'Unauthorized access. Please login again.';
  static const String notFoundError = 'Resource not found.';
  static const String validationError = 'Validation failed. Please check your input.';
  static const String unknownError = 'An unknown error occurred.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String emptyFieldError = 'This field cannot be empty.';
  static const String invalidEmailError = 'Please enter a valid email address.';
  static const String weakPasswordError = 'Password must be at least 8 characters long.';
  static const String passwordMismatchError = 'Passwords do not match.';
  static const String cartEmptyError = 'Your cart is empty.';
  static const String paymentFailedError = 'Payment failed. Please try again.';
}

// Success Messages
class SuccessMessages {
  static const String loginSuccess = 'Login successful!';
  static const String registrationSuccess = 'Registration successful! Please login.';
  static const String logoutSuccess = 'Logged out successfully.';
  static const String orderPlacedSuccess = 'Order placed successfully!';
  static const String reservationSuccess = 'Reservation confirmed!';
  static const String profileUpdatedSuccess = 'Profile updated successfully.';
  static const String itemAddedToCart = 'Item added to cart.';
  static const String itemRemovedFromCart = 'Item removed from cart.';
}

// Duration Constants
class DurationConstants {
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 1000);
  static const Duration snackbarDuration = Duration(seconds: 2);
  static const Duration toastDuration = Duration(seconds: 3);
}

// Size Constants
class SizeConstants {
  // Padding & Margin
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;

  // Button Height
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;

  // Image Heights
  static const double foodImageHeight = 200.0;
  static const double bannerHeight = 180.0;
  static const double profileImageSize = 100.0;
}
