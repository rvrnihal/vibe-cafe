import 'package:vibe_cafe/core/errors/exceptions.dart';
import 'package:vibe_cafe/data/models/food_item_model.dart';
import 'package:vibe_cafe/data/models/order_model.dart';
import 'package:vibe_cafe/data/models/reservation_model.dart';
import 'package:vibe_cafe/core/constants/enums.dart';

abstract class RemoteDataSource {
  Future<List<FoodItem>> getFoodItems();
  Future<List<FoodItem>> searchFoodItems(String query);
  Future<FoodItem> getFoodItemById(String id);
  Future<List<Order>> getUserOrders(String userId);
  Future<Order> placeOrder(Order order);
  Future<Order> cancelOrder(String orderId, String reason);
  Future<List<Reservation>> getUserReservations(String userId);
  Future<Reservation> createReservation(Reservation reservation);
  Future<Reservation> cancelReservation(String reservationId, String reason);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  // Mock data for demonstration
  static final List<FoodItem> _mockFoodItems = [
    FoodItem(
      id: '1',
      name: 'Biryani',
      description: 'Delicious rice biryani with meat',
      price: 250.0,
      imageUrl: 'assets/images/food1.jpeg',
      rating: 4.5,
      reviewCount: 150,
      category: FoodCategory.mainCourse,
      isPopular: true,
      flavors: ['Chicken', 'Mutton', 'Veg'],
      customizationOptions: ['Extra Rice', 'More Spicy', 'Less Oil'],
      preparationTime: 30,
    ),
    FoodItem(
      id: '2',
      name: 'Butter Chicken',
      description: 'Creamy tomato-based curry with chicken',
      price: 280.0,
      imageUrl: 'assets/images/food2.jpeg',
      rating: 4.7,
      reviewCount: 200,
      category: FoodCategory.mainCourse,
      isPopular: true,
      flavors: ['Medium Spice', 'High Spice', 'Mild'],
      customizationOptions: ['Extra Gravy', 'More Butter', 'Less Cream'],
      preparationTime: 25,
    ),
    FoodItem(
      id: '3',
      name: 'Paneer Tikka',
      description: 'Grilled cottage cheese with spices',
      price: 200.0,
      imageUrl: 'assets/images/food3.jpeg',
      rating: 4.6,
      reviewCount: 180,
      category: FoodCategory.appetizers,
      isVegan: true,
      isGlutenFree: true,
      flavors: ['Classic', 'Tandoori', 'Malai'],
      customizationOptions: ['Extra Mint', 'More Lemon', 'Hot Sauce'],
      preparationTime: 20,
      discount: 10.0,
    ),
    FoodItem(
      id: '4',
      name: 'Chocolate Cake',
      description: 'Rich and moist chocolate cake',
      price: 150.0,
      imageUrl: 'assets/images/food4.jpeg',
      rating: 4.8,
      reviewCount: 250,
      category: FoodCategory.desserts,
      flavors: ['Dark', 'Milk', 'White'],
      customizationOptions: ['Extra Frosting', 'Sprinkles', 'Candles'],
      preparationTime: 10,
    ),
    FoodItem(
      id: '5',
      name: 'Iced Coffee',
      description: 'Refreshing cold coffee with ice cream',
      price: 120.0,
      imageUrl: 'assets/images/food5.jpeg',
      rating: 4.4,
      reviewCount: 300,
      category: FoodCategory.beverages,
      flavors: ['Classic', 'Vanilla', 'Caramel'],
      customizationOptions: ['Extra Ice', 'More Syrup', 'Whipped Cream'],
      preparationTime: 5,
    ),
  ];

  @override
  Future<List<FoodItem>> getFoodItems() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockFoodItems;
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch food items',
        originalException: e,
      );
    }
  }

  @override
  Future<List<FoodItem>> searchFoodItems(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final queryLower = query.toLowerCase();
      return _mockFoodItems
          .where((item) =>
              item.name.toLowerCase().contains(queryLower) ||
              item.description.toLowerCase().contains(queryLower))
          .toList();
    } catch (e) {
      throw ServerException(
        message: 'Search failed',
        originalException: e,
      );
    }
  }

  @override
  Future<FoodItem> getFoodItemById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final item = _mockFoodItems.firstWhere(
        (item) => item.id == id,
        orElse: () => throw ClientException(
          message: 'Food item not found',
          code: '404',
        ),
      );
      return item;
    } catch (e) {
      if (e is ClientException) rethrow;
      throw ServerException(
        message: 'Failed to fetch food item',
        originalException: e,
      );
    }
  }

  @override
  Future<List<Order>> getUserOrders(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return empty list for demo
      return [];
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch orders',
        originalException: e,
      );
    }
  }

  @override
  Future<Order> placeOrder(Order order) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock success response
      return order.copyWith(
        status: OrderStatus.confirmed,
        paymentStatus: PaymentStatus.completed,
      );
    } catch (e) {
      throw PaymentException(
        message: 'Failed to place order',
        originalException: e,
      );
    }
  }

  @override
  Future<Order> cancelOrder(String orderId, String reason) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      return Order(
        id: orderId,
        userId: '',
        items: [],
        subtotal: 0,
        tax: 0,
        deliveryCharge: 0,
        totalAmount: 0,
        status: OrderStatus.cancelled,
        paymentStatus: PaymentStatus.refunded,
        paymentMethod: PaymentMethod.cod,
        deliveryType: DeliveryType.delivery,
        createdAt: DateTime.now(),
        cancelledReason: reason,
      );
    } catch (e) {
      throw ServerException(
        message: 'Failed to cancel order',
        originalException: e,
      );
    }
  }

  @override
  Future<List<Reservation>> getUserReservations(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      return [];
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch reservations',
        originalException: e,
      );
    }
  }

  @override
  Future<Reservation> createReservation(Reservation reservation) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      return reservation.copyWith(status: ReservationStatus.confirmed);
    } catch (e) {
      throw ServerException(
        message: 'Failed to create reservation',
        originalException: e,
      );
    }
  }

  @override
  Future<Reservation> cancelReservation(
    String reservationId,
    String reason,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      return Reservation(
        id: reservationId,
        userId: '',
        reservationDate: DateTime.now(),
        reservationTime: DateTime.now(),
        numberOfPeople: 0,
        status: ReservationStatus.cancelled,
        createdAt: DateTime.now(),
        cancellationReason: reason,
      );
    } catch (e) {
      throw ServerException(
        message: 'Failed to cancel reservation',
        originalException: e,
      );
    }
  }
}
