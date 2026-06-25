import 'package:vibe_cafe/core/constants/enums.dart';
import 'package:vibe_cafe/data/models/cart_item_model.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double deliveryCharge;
  final double? discount;
  final double totalAmount;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final DeliveryType deliveryType;
  final String? deliveryAddress;
  final DateTime? reservationDate;
  final DateTime? reservationTime;
  final int? numberOfPeople;
  final String? specialRequests;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final String? trackingId;
  final String? cancelledReason;
  final double? rating;
  final String? review;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryCharge,
    this.discount,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.deliveryType,
    this.deliveryAddress,
    this.reservationDate,
    this.reservationTime,
    this.numberOfPeople,
    this.specialRequests,
    required this.createdAt,
    this.estimatedDeliveryTime,
    this.trackingId,
    this.cancelledReason,
    this.rating,
    this.review,
  });

  bool get canCancel => status == OrderStatus.pending || status == OrderStatus.confirmed;
  bool get isCompleted => status == OrderStatus.delivered;
  bool get isCancelled => status == OrderStatus.cancelled;

  Order copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? deliveryCharge,
    double? discount,
    double? totalAmount,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    DeliveryType? deliveryType,
    String? deliveryAddress,
    DateTime? reservationDate,
    DateTime? reservationTime,
    int? numberOfPeople,
    String? specialRequests,
    DateTime? createdAt,
    DateTime? estimatedDeliveryTime,
    String? trackingId,
    String? cancelledReason,
    double? rating,
    String? review,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryType: deliveryType ?? this.deliveryType,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      specialRequests: specialRequests ?? this.specialRequests,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      trackingId: trackingId ?? this.trackingId,
      cancelledReason: cancelledReason ?? this.cancelledReason,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'deliveryCharge': deliveryCharge,
      'discount': discount,
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'paymentMethod': paymentMethod.name,
      'deliveryType': deliveryType.name,
      'deliveryAddress': deliveryAddress,
      'reservationDate': reservationDate?.toIso8601String(),
      'reservationTime': reservationTime?.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'specialRequests': specialRequests,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
      'trackingId': trackingId,
      'cancelledReason': cancelledReason,
      'rating': rating,
      'review': review,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ?? [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.byName(json['status'] ?? 'pending'),
      paymentStatus: PaymentStatus.values.byName(json['paymentStatus'] ?? 'pending'),
      paymentMethod: PaymentMethod.values.byName(json['paymentMethod'] ?? 'cod'),
      deliveryType: DeliveryType.values.byName(json['deliveryType'] ?? 'delivery'),
      deliveryAddress: json['deliveryAddress'],
      reservationDate: json['reservationDate'] != null
          ? DateTime.parse(json['reservationDate'])
          : null,
      reservationTime: json['reservationTime'] != null
          ? DateTime.parse(json['reservationTime'])
          : null,
      numberOfPeople: json['numberOfPeople'],
      specialRequests: json['specialRequests'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'])
          : null,
      trackingId: json['trackingId'],
      cancelledReason: json['cancelledReason'],
      rating: (json['rating'] as num?)?.toDouble(),
      review: json['review'],
    );
  }

  @override
  String toString() => 'Order(id: $id, userId: $userId, totalAmount: $totalAmount)';
}
