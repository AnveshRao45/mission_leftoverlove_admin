import 'dart:convert';

class Order {
  List<MenuItem>? menu;
  Restaurant? restaurant;
  double? orderValue;
  String? orderStatus;
  OrderDetails? orderDetails;

  Order({
    this.menu,
    this.restaurant,
    this.orderValue,
    this.orderStatus,
    this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      menu: (json['menu'] as List?)
          ?.map((item) => MenuItem.fromJson(item))
          .toList(),
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'])
          : null,
      orderValue: (json['order_value'] as num?)?.toDouble(),
      orderStatus: json['order_status'] as String?,
      orderDetails: json['order_details'] != null
          ? OrderDetails.fromJson(json['order_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': menu?.map((item) => item.toJson()).toList(),
      'restaurent': restaurant?.toJson(),
      'order_value': orderValue,
      'order_status': orderStatus,
      'order_details': orderDetails?.toJson(),
    };
  }
}

class MenuItem {
  int? menuId;
  String? menuName;
  String? menuImage;
  double? menuPrice;
  bool? menuIsVeg;
  String? menuDescription;
  int? orderedQuantity;
  double? menuActualPrice;

  MenuItem({
    this.menuId,
    this.menuName,
    this.menuImage,
    this.menuPrice,
    this.menuIsVeg,
    this.menuDescription,
    this.orderedQuantity,
    this.menuActualPrice,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menuId: json['menu_id'] as int?,
      menuName: json['menu_name'] as String?,
      menuImage: json['menu_image'] as String?,
      menuPrice: (json['menu_price'] as num?)?.toDouble(),
      menuIsVeg: json['menu_is_veg'] as bool?,
      menuDescription: json['menu_description'] as String?,
      orderedQuantity: json['ordered_quantity'] as int?,
      menuActualPrice: (json['menu_actual_price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_id': menuId,
      'menu_name': menuName,
      'menu_image': menuImage,
      'menu_price': menuPrice,
      'menu_is_veg': menuIsVeg,
      'menu_description': menuDescription,
      'ordered_quantity': orderedQuantity,
      'menu_actual_price': menuActualPrice,
    };
  }
}

class Restaurant {
  int? restaurantId;
  String? restaurantName;
  String? restaurantAddress;
  List<dynamic>? restaurantPhone;
  double? latitude;
  double? longitude;
  String? endTime;
  String? pickupTime;

  Restaurant({
    this.restaurantId,
    this.restaurantName,
    this.restaurantAddress,
    this.restaurantPhone,
    this.latitude,
    this.longitude,
    this.endTime,
    this.pickupTime,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantId: json['restaurant_id'] as int?,
      restaurantName: json['restaurant_name'] as String?,
      restaurantAddress: json['restaurant_address'] as String?,
      restaurantPhone: json['restaurant_phone'] as List<dynamic>?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      endTime: json['end_time'] as String?,
      pickupTime: json['pickup_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurent_id': restaurantId,
      'restaurent_name': restaurantName,
      'restaurent_address': restaurantAddress,
      'restaurent_phone': restaurantPhone,
      'latitude': latitude,
      'longitude': longitude,
      'end_time': endTime,
      'pickup_time': pickupTime,
    };
  }
}

class OrderDetails {
  int? orderId;
  String? orderDate;

  OrderDetails({
    this.orderId,
    this.orderDate,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      orderId: json['order_id'] as int?,
      orderDate: json['order_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_date': orderDate,
    };
  }
}

class OrderStatus {
  final int paramOrderId;
  final String message;

  OrderStatus({required this.paramOrderId, required this.message});

  // Factory method to create an instance from JSON
  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      paramOrderId: json['param_order_id'],
      message: json['message'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'param_order_id': paramOrderId,
      'message': message,
    };
  }
}

// Updated method to parse a list of restaurant JSON objects into a list of Restaurent Model
List<Order> parseAllOrders(List<dynamic> jsonList) {
  return jsonList.map((json) => Order.fromJson(json)).toList();
}

enum BookingStatus { booked, picked, noShowCancelled, cancelled, refund }

parseOrderResponse(List<dynamic> jsonList) {
  if (jsonList.isNotEmpty) {
    final firstObject = jsonList.first as Map<String, dynamic>;
    return OrderStatus.fromJson(firstObject);
  } else {
    throw Exception("Response list is empty.");
  }
}

enum OrderCreation { failure, success }
