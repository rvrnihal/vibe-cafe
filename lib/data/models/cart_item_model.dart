class CartItem {
  final String id;
  final String foodItemId;
  final String foodName;
  final String foodImage;
  final double foodPrice;
  final int quantity;
  final String? selectedFlavor;
  final List<String> selectedCustomizations;
  final String? specialInstructions;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.foodItemId,
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
    required this.quantity,
    this.selectedFlavor,
    this.selectedCustomizations = const [],
    this.specialInstructions,
    required this.addedAt,
  });

  double get subtotal => foodPrice * quantity;

  CartItem copyWith({
    String? id,
    String? foodItemId,
    String? foodName,
    String? foodImage,
    double? foodPrice,
    int? quantity,
    String? selectedFlavor,
    List<String>? selectedCustomizations,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      foodItemId: foodItemId ?? this.foodItemId,
      foodName: foodName ?? this.foodName,
      foodImage: foodImage ?? this.foodImage,
      foodPrice: foodPrice ?? this.foodPrice,
      quantity: quantity ?? this.quantity,
      selectedFlavor: selectedFlavor ?? this.selectedFlavor,
      selectedCustomizations: selectedCustomizations ?? this.selectedCustomizations,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodItemId': foodItemId,
      'foodName': foodName,
      'foodImage': foodImage,
      'foodPrice': foodPrice,
      'quantity': quantity,
      'selectedFlavor': selectedFlavor,
      'selectedCustomizations': selectedCustomizations,
      'specialInstructions': specialInstructions,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      foodItemId: json['foodItemId'] ?? '',
      foodName: json['foodName'] ?? '',
      foodImage: json['foodImage'] ?? '',
      foodPrice: (json['foodPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
      selectedFlavor: json['selectedFlavor'],
      selectedCustomizations: List<String>.from(json['selectedCustomizations'] ?? []),
      specialInstructions: json['specialInstructions'],
      addedAt: DateTime.parse(json['addedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  String toString() => 'CartItem(id: $id, foodName: $foodName, quantity: $quantity)';
}
