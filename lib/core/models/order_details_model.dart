class OrderDetail {
  final int orderDetId; // Corresponds to order_det_id (bigint/int8)
  final int orderId; // Corresponds to order_id (bigint/int8)
  final int menuItemId; // Corresponds to menu_item_id (bigint/int8)
  final int quantity; // Corresponds to quantity (integer/int4)
  final DateTime orderedDate; // Corresponds to ordered_date (date)

  OrderDetail({
    required this.orderDetId,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.orderedDate,
  });

  // Factory method to create an OrderDetail object from a JSON map
  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderDetId: json['order_det_id'] as int,
      orderId: json['order_id'] as int,
      menuItemId: json['menu_item_id'] as int,
      quantity: json['quantity'] as int,
      orderedDate: DateTime.parse(json['ordered_date'] as String),
    );
  }

  // Method to convert an OrderDetail object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'order_det_id': orderDetId,
      'order_id': orderId,
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'ordered_date': orderedDate.toIso8601String(),
    };
  }
}

List<dynamic> parseOrderDetailsList(Map<String, dynamic> data) {
  final List<dynamic> orderDetailsList =
      data['order_details']; // Adjust the key as per your RPC response
  return orderDetailsList
      .map((json) => OrderDetail.fromJson(json as dynamic))
      .toList();
}
