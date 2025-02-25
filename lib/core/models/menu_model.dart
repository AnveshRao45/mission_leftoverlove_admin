class MenuModel {
  final int menuId;
  final int restaurentId;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final double actualPrice;
  final bool isVeg;
  final String image;
  final String? categoryName;
  final String? subcategoryName;

  MenuModel({
    required this.menuId,
    required this.restaurentId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.actualPrice,
    required this.isVeg,
    required this.image,
    this.categoryName,
    this.subcategoryName,
  });

  // Factory method to create a MenuModel from JSON
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      menuId: json['menu_id'],
      restaurentId: json['restaurent_id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      actualPrice: (json['actual_price'] as num).toDouble(),
      isVeg: json['is_veg'],
      image: json['image'],
      categoryName: json['category_name'],
      subcategoryName: json['subcategory_name'],
    );
  }

  // Method to convert a MenuModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'menu_id': menuId,
      'restaurent_id': restaurentId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'actual_price': actualPrice,
      'is_veg': isVeg,
      'image': image,
      'category_name': categoryName,
    };
  }
}

List<MenuModel> parseMenuList(List<dynamic> jsonList) {
  return jsonList
      .map((item) => MenuModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
