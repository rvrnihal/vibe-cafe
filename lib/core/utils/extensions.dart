import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Format date as 'MMM dd, yyyy'
  String toFormattedDate() {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Format date as 'dd/MM/yyyy'
  String toDateString() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Format time as 'hh:mm a'
  String toTimeString() {
    return DateFormat('hh:mm a').format(this);
  }

  /// Format as 'MMM dd, yyyy - hh:mm a'
  String toFormattedDateTime() {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(this);
  }

  /// Check if date is today
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is tomorrow
  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Get relative time string (e.g., "2 hours ago")
  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return toFormattedDate();
    }
  }
}

extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if email is valid
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if phone number is valid (10 digits)
  bool isValidPhone() {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if password is strong
  bool isStrongPassword() {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(this);
  }

  /// Truncate text to specified length
  String truncate(int length) {
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }

  /// Remove all whitespace
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }
}

extension NumExtensions on num {
  /// Format as currency (₹)
  String toCurrency() {
    return '₹${toStringAsFixed(2)}';
  }

  /// Format as price (without ₹)
  String toPrice() {
    return toStringAsFixed(2);
  }

  /// Format as compact number (e.g., 1.5K, 2.3M)
  String toCompactNumber() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}

extension DurationExtensions on Duration {
  /// Convert to readable format (e.g., "2h 30m")
  String toReadableFormat() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

extension BuildContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if device is in landscape
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if device is in portrait
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Get device padding (safe area)
  EdgeInsets get devicePadding => MediaQuery.of(this).padding;

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Push named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Push replacement route
  Future<T?> pushReplacementNamed<T, TO>(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  /// Pop current route
  void pop<T>([T? result]) => Navigator.of(this).pop<T>(result);

  /// Show snackbar
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message,
      {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message,
      {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

extension ListExtensions<T> on List<T> {
  /// Check if list is empty
  bool get isEmpty => length == 0;

  /// Check if list is not empty
  bool get isNotEmpty => length > 0;

  /// Safely get element at index
  T? safeElementAt(int index) {
    if (index < 0 || index >= length) return null;
    return elementAt(index);
  }

  /// Swap two elements
  void swap(int index1, int index2) {
    if (index1 < length && index2 < length) {
      final temp = this[index1];
      this[index1] = this[index2];
      this[index2] = temp;
    }
  }
}

extension MapExtensions<K, V> on Map<K, V> {
  /// Get value or default
  V? getOrDefault(K key, V? defaultValue) {
    return containsKey(key) ? this[key] : defaultValue;
  }

  /// Merge two maps
  Map<K, V> merge(Map<K, V> other) {
    return {...this, ...other};
  }
}
