import 'package:vibe_cafe/core/constants/enums.dart';

class Reservation {
  final String id;
  final String userId;
  final DateTime reservationDate;
  final DateTime reservationTime;
  final int numberOfPeople;
  final ReservationStatus status;
  final String? specialRequests;
  final String? tablePreference;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? cancellationReason;

  Reservation({
    required this.id,
    required this.userId,
    required this.reservationDate,
    required this.reservationTime,
    required this.numberOfPeople,
    required this.status,
    this.specialRequests,
    this.tablePreference,
    required this.createdAt,
    this.updatedAt,
    this.cancellationReason,
  });

  bool get canCancel =>
      status == ReservationStatus.pending || status == ReservationStatus.confirmed;

  Reservation copyWith({
    String? id,
    String? userId,
    DateTime? reservationDate,
    DateTime? reservationTime,
    int? numberOfPeople,
    ReservationStatus? status,
    String? specialRequests,
    String? tablePreference,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? cancellationReason,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      status: status ?? this.status,
      specialRequests: specialRequests ?? this.specialRequests,
      tablePreference: tablePreference ?? this.tablePreference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'reservationDate': reservationDate.toIso8601String(),
      'reservationTime': reservationTime.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'status': status.name,
      'specialRequests': specialRequests,
      'tablePreference': tablePreference,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      reservationDate: DateTime.parse(json['reservationDate'] ?? DateTime.now().toIso8601String()),
      reservationTime: DateTime.parse(json['reservationTime'] ?? DateTime.now().toIso8601String()),
      numberOfPeople: json['numberOfPeople'] ?? 1,
      status: ReservationStatus.values.byName(json['status'] ?? 'pending'),
      specialRequests: json['specialRequests'],
      tablePreference: json['tablePreference'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      cancellationReason: json['cancellationReason'],
    );
  }

  @override
  String toString() => 'Reservation(id: $id, userId: $userId, numberOfPeople: $numberOfPeople)';
}
