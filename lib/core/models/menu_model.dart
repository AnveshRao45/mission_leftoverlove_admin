class MenuModel {
  final int? menuId;
  final int restaurantId;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final double actualPrice;
  final bool isVeg;
  final String image;
  final String? categoryName;
  final String? subcategoryName;
  final bool? isActive;

  MenuModel({
    this.menuId,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.actualPrice,
    required this.isVeg,
    required this.image,
    this.categoryName,
    this.subcategoryName,
    this.isActive,
  });

  // Factory method to create a MenuModel from JSON
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      menuId: (json['menu_id'] as num?)?.toInt() ?? 0, // Default to 0 if null
      restaurantId: (json['restaurant_id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      actualPrice: (json['actual_price'] as num?)?.toDouble() ?? 0.0,
      isVeg: json['is_veg'] as bool? ?? false,
      image: json['image'] as String? ?? '',
      categoryName: json['category_name'] as String?,
      subcategoryName: json['subcategory_name'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  // Method to convert a MenuModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'menu_id': menuId,
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'actual_price': actualPrice,
      'is_veg': isVeg,
      'image': image,
      'category_name': categoryName,
      'is_active': isActive,
    };
  }

  // CopyWith method to create a new instance with updated fields
  MenuModel copyWith({
    int? menuId,
    int? restaurantId,
    String? name,
    String? description,
    int? quantity,
    double? price,
    double? actualPrice,
    bool? isVeg,
    String? image,
    String? categoryName,
    String? subcategoryName,
    bool? isActive,
  }) {
    return MenuModel(
      menuId: menuId ?? this.menuId,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      actualPrice: actualPrice ?? this.actualPrice,
      isVeg: isVeg ?? this.isVeg,
      image: image ?? this.image,
      categoryName: categoryName ?? this.categoryName,
      subcategoryName: subcategoryName ?? this.subcategoryName,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Helper function to parse a list of JSON objects into a list of MenuModel objects
List<MenuModel> parseMenuList(List<dynamic> jsonList) {
  return jsonList
      .map((item) => MenuModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
