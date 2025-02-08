import 'package:mission_leftoverlove_admin/core/models/menu_model.dart';

class CartModel {
  final String? restaurantId;
  final List<Map<String, MenuModel>>? foodItems;
  final String? totalPrice;

  CartModel({this.restaurantId, this.foodItems, this.totalPrice});

  // Factory constructor to create a CartModel from a JSON map
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        restaurantId: json['restaurantId'] as String?,
        foodItems: (json['foodItems'] as List<dynamic>?)
            ?.map((item) => (item as Map<String, dynamic>).map(
                  (key, value) => MapEntry(key, MenuModel.fromJson(value)),
                ))
            .toList(),
        totalPrice: json['totalPrice']);
  }

  // Method to convert a CartModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'foodItems': foodItems
          ?.map(
              (item) => item.map((key, value) => MapEntry(key, value.toJson())))
          .toList(),
      'totalPrice': totalPrice
    };
  }
}
