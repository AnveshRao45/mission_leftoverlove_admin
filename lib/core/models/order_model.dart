class Order {
  final int orderId;
  final String userId;
  final int restaurantId;
  final String orderStat;
  final double orderValue;
  final DateTime orderDate;

  Order({
    required this.orderId,
    required this.userId,
    required this.restaurantId,
    required this.orderStat,
    required this.orderValue,
    required this.orderDate,
  });

  // Factory method to create an Order object from a JSON map
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'] as int,
      userId: json['user_id'] as String,
      restaurantId: json['restaurent_id'] as int,
      orderStat: json['order_stat'] as String,
      orderValue: json['order_value'] as double,
      orderDate: DateTime.parse(json['order_date'] as String),
    );
  }

  // Method to convert an Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'restaurent_id': restaurantId,
      'order_stat': orderStat,
      'order_value': orderValue,
      'order_date': orderDate.toIso8601String(),
    };
  }
}
