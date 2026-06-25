class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final DateTime? dateOfBirth;
  final List<String>? favoriteIds;
  final double? walletBalance;
  final int? loyaltyPoints;
  final DateTime createdAt;
  final DateTime? lastUpdatedAt;
  final bool isVerified;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.dateOfBirth,
    this.favoriteIds,
    this.walletBalance = 0.0,
    this.loyaltyPoints = 0,
    required this.createdAt,
    this.lastUpdatedAt,
    this.isVerified = false,
    this.isActive = true,
  });

  String get fullAddress =>
      '$address, $city, $state - $pincode';

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? address,
    String? city,
    String? state,
    String? pincode,
    DateTime? dateOfBirth,
    List<String>? favoriteIds,
    double? walletBalance,
    int? loyaltyPoints,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    bool? isVerified,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      walletBalance: walletBalance ?? this.walletBalance,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'favoriteIds': favoriteIds,
      'walletBalance': walletBalance,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      'isVerified': isVerified,
      'isActive': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      favoriteIds: List<String>.from(json['favoriteIds'] ?? []),
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastUpdatedAt: json['lastUpdatedAt'] != null ? DateTime.parse(json['lastUpdatedAt']) : null,
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
