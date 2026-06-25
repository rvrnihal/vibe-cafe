import 'package:vibe_cafe/core/constants/enums.dart';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final FoodCategory category;
  final bool isFavorite;
  final bool isPopular;
  final List<String> flavors;
  final List<String> customizationOptions;
  final int preparationTime; // in minutes
  final bool isVegan;
  final bool isGlutenFree;
  final double? discount; // discount percentage

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.category,
    this.isFavorite = false,
    this.isPopular = false,
    this.flavors = const [],
    this.customizationOptions = const [],
    this.preparationTime = 30,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.discount,
  });

  double get discountedPrice {
    if (discount == null || discount == 0) return price;
    return price - (price * discount! / 100);
  }

  double get discountAmount {
    if (discount == null || discount == 0) return 0;
    return price * discount! / 100;
  }

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    FoodCategory? category,
    bool? isFavorite,
    bool? isPopular,
    List<String>? flavors,
    List<String>? customizationOptions,
    int? preparationTime,
    bool? isVegan,
    bool? isGlutenFree,
    double? discount,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      isPopular: isPopular ?? this.isPopular,
      flavors: flavors ?? this.flavors,
      customizationOptions: customizationOptions ?? this.customizationOptions,
      preparationTime: preparationTime ?? this.preparationTime,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      discount: discount ?? this.discount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category.name,
      'isFavorite': isFavorite,
      'isPopular': isPopular,
      'flavors': flavors,
      'customizationOptions': customizationOptions,
      'preparationTime': preparationTime,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'discount': discount,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      category: FoodCategory.values.byName(
        json['category'] ?? 'snacks',
      ),
      isFavorite: json['isFavorite'] ?? false,
      isPopular: json['isPopular'] ?? false,
      flavors: List<String>.from(json['flavors'] ?? []),
      customizationOptions: List<String>.from(json['customizationOptions'] ?? []),
      preparationTime: json['preparationTime'] ?? 30,
      isVegan: json['isVegan'] ?? false,
      isGlutenFree: json['isGlutenFree'] ?? false,
      discount: (json['discount'] as num?)?.toDouble(),
    );
  }

  @override
  String toString() => 'FoodItem(id: $id, name: $name, price: $price)';
}
