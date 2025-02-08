class RestaurentModel {
  final int? restaurantId;
  final String? name;
  final String? description;
  final double? rating;
  final double? mealsLeft;
  final double? latitude;
  final double? longitude;
  final String? cuisine;
  final List<String>? images;
  final bool? isActive;
  final double? distMeters;
  final String? pickupTime; // Assuming stored as text in database
  final String? endTime; // Assuming stored as text in database
  final List<String>? elgibleCategory;

  RestaurentModel(
      {this.restaurantId,
      this.name,
      this.description,
      this.rating,
      this.mealsLeft,
      this.latitude,
      this.longitude,
      this.cuisine,
      this.distMeters,
      this.images,
      this.isActive,
      this.pickupTime,
      this.endTime,
      this.elgibleCategory});

  // Factory constructor to create an instance from a JSON object
  factory RestaurentModel.fromJson(dynamic json) {
    return RestaurentModel(
        restaurantId: json['restaurant_id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        mealsLeft: (json['meals_left'] as num?)?.toDouble(),
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        cuisine: json['cuisine'] as String?,
        images: (json['images'] as List<dynamic>?)
            ?.map((image) => image as String)
            .toList(),
        isActive: json['isActive'] as bool?,
        distMeters: (json['dist_meters'] as num?)?.toDouble(),
        pickupTime: json['pickup_time'] as String?, // Parse pickup_time
        endTime: json['end_time'] as String?, // Parse end_time,
        elgibleCategory: (json['category_names'] as List<dynamic>?)
            ?.map((image) => image as String)
            .toList());
  }

  // Method to convert the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'rating': rating,
      'meals_left': mealsLeft,
      'latitude': latitude,
      'longitude': longitude,
      'cuisine': cuisine,
      'category_names': elgibleCategory,
      'images': images,
      'isActive': isActive,
      'dist_meters': distMeters,
      'pickup_time': pickupTime, // Include pickup_time
      'end_time': endTime // Include end_time
    };
  }
}

// Updated method to parse a list of restaurant JSON objects into a list of RestaurentModel
List<RestaurentModel> parseRestaurantList(List<dynamic> jsonList) {
  return jsonList.map((json) => RestaurentModel.fromJson(json)).toList();
}

// Updated method to parse a list of maps into Map<int, RestaurentModel>
Map<int, RestaurentModel> parseRestaurentMap(List<dynamic> list) {
  return {
    for (var json in list)
      if (json['restaurant_id'] != null)
        json['restaurant_id'] as int: RestaurentModel.fromJson(json)
  };
}
