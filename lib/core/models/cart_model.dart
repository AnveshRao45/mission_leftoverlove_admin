import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';

class CartModel {
  final String? restaurantId;
  final List<CartFood>? foodItems;

  CartModel({
    this.restaurantId,
    this.foodItems,
  });

  // Convert a CartModel object to a Map (useful for serialization)
  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'foodItems': foodItems?.map((item) => item.toMap()).toList(),
    };
  }

  // Create a CartModel object from a Map (useful for deserialization)
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      restaurantId: map['restaurantId'] as String?,
      foodItems: (map['foodItems'] as List<dynamic>?)
          ?.map((item) => CartFood.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() =>
      'CartModel(restaurantId: $restaurantId, foodItems: $foodItems)';
}

class CartFood {
  final int restaurantId;

  int selectedQuantity;
  final MenuModel food;

  CartFood(
      {required this.restaurantId,
      this.selectedQuantity = 1, // Default value for selectedQuantity
      required this.food});

  // Convert a CartFood object to a Map (useful for serialization)
  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'selectedQuantity': selectedQuantity,
      'food': food.toJson()
    };
  }

  // Create a CartFood object from a Map (useful for deserialization)
  factory CartFood.fromMap(Map<String, dynamic> map) {
    return CartFood(
      restaurantId: map['restaurantId'] as int,
      food: MenuModel.fromJson(map['food']),
      selectedQuantity: map['selectedQuantity'] as int? ?? 1, // Default if null
    );
  }

  // Method to convert List<CartFood> to JSON
  static List<Map<String, dynamic>> listToJson(List<CartFood> cartFoods) {
    return cartFoods.map((cartFood) => cartFood.toMap()).toList();
  }

  @override
  String toString() =>
      'CartFood(menuId: , selectedQuantity: $selectedQuantity, )';
}

class PaymentModel {
  final double actualPrice;
  final double price;
  final double gst;
  final double totalActualBill;
  final double platformFee;
  final double bill;

  PaymentModel(
      {required this.actualPrice,
      required this.price,
      required this.totalActualBill,
      required this.gst,
      required this.platformFee,
      required this.bill});

  // Factory method to create an instance from a map (e.g., from JSON)
  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
        actualPrice: map['actualPrice'] ?? 0.0,
        totalActualBill: map['totalActualBill'] ?? 0.0,
        price: map['price'] ?? 0.0,
        gst: map['gst'] ?? 0.0,
        platformFee: map['platformFee'] ?? 0.0,
        bill: map['bill'] ?? 0.0);
  }

  // Method to convert an instance to a map (e.g., for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'actualPrice': actualPrice,
      'price': price,
      'totalActualBill': totalActualBill,
      'gst': gst,
      'platformFee': platformFee,
      'bill': bill
    };
  }
}
