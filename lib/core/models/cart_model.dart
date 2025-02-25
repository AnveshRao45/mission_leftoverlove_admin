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
  final int restaurentId;
  final int menuId;
  int selectedQuantity;
  final double price;
  final String name;
  final String actualPrice;
  final bool isVeg;

  CartFood({
    required this.restaurentId,
    required this.menuId,
    this.selectedQuantity = 1, // Default value for selectedQuantity
    required this.price,
    required this.isVeg,
    required this.name,
    required this.actualPrice,
  });

  // Convert a CartFood object to a Map (useful for serialization)
  Map<String, dynamic> toMap() {
    return {
      'restaurentId': restaurentId,
      'menuId': menuId,
      'selectedQuantity': selectedQuantity,
      'price': price,
      'isVeg': isVeg,
      'name': name,
      'actualPrice': actualPrice,
    };
  }

  // Create a CartFood object from a Map (useful for deserialization)
  factory CartFood.fromMap(Map<String, dynamic> map) {
    return CartFood(
      restaurentId: map['restaurentId'] as int,
      menuId: map['menuId'] as int,
      selectedQuantity: map['selectedQuantity'] as int? ?? 1, // Default if null
      price: map['price'] as double,
      isVeg: map['isVeg'] as bool,
      name: map['name'] as String,
      actualPrice: map['actualPrice'] as String,
    );
  }

  @override
  String toString() =>
      'CartFood(menuId: $menuId, selectedQuantity: $selectedQuantity, price: $price)';
}

class PaymentModel {
  final double actualPrice;
  final double price;
  final double gst;
  final double platformFee;
  final double bill;

  PaymentModel(
      {required this.actualPrice,
      required this.price,
      required this.gst,
      required this.platformFee,
      required this.bill});

  // Factory method to create an instance from a map (e.g., from JSON)
  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
        actualPrice: map['actualPrice'] ?? 0.0,
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
      'gst': gst,
      'platformFee': platformFee,
      'bill': bill
    };
  }
}
