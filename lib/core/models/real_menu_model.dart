class RealMenuModel {
  final int? menuId;
  final int? restaurantId;
  final String? itemName;
  final String? description;
  final double? price;
  final bool? isVeg;
  final double? actualPrice;
  final String? image;
  final int? quantity;
  final int? cuisine;
  final int? categoryId;
  final int? subcategoryId;
  final bool? isActive;

  RealMenuModel({
    this.menuId,
    this.restaurantId,
    this.itemName,
    this.description,
    this.price,
    this.isVeg,
    this.actualPrice,
    this.image,
    this.quantity,
    this.cuisine,
    this.categoryId,
    this.subcategoryId,
    this.isActive,
  });

  // Convert JSON to Model
  factory RealMenuModel.fromJson(Map<String, dynamic> json) {
    return RealMenuModel(
      menuId: json['menu_id'],
      restaurantId: json['restaurant_id'],
      itemName: json['item_name'],
      description: json['description'],
      price: (json['price'] as num?)?.toDouble(),
      isVeg: json['is_veg'] == 1,
      actualPrice: (json['actual_price'] as num?)?.toDouble(),
      image: json['image'],
      quantity: json['quantity'],
      cuisine: json['cuisuine'],
      categoryId: json['category_id'],
      subcategoryId: json['subcategory_id'],
      isActive: json['is_active'] == 1,
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'menu_id': menuId,
      'restaurant_id': restaurantId,
      'item_name': itemName,
      'description': description,
      'price': price,
      'is_veg': isVeg == true ? 1 : 0,
      'actual_price': actualPrice,
      'image': image,
      'quantity': quantity,
      'cuisuine': cuisine,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'is_active': isActive == true ? 1 : 0,
    };
  }
}
