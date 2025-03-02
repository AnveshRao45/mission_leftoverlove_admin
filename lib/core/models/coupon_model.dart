class Coupon {
  final int? couponId;
  final int? restaurantId;
  final String code;
  final String? description;
  final String discountType; // 'fixed' or 'percentage'
  final double discountValue;
  final double? minOrderValue;
  final double? maxDiscount;
  final int? usageLimit;
  final int? usageLimitPerUser;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Coupon({
    this.couponId,
    this.restaurantId,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.minOrderValue,
    this.maxDiscount,
    this.usageLimit,
    this.usageLimitPerUser,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Coupon from JSON data
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      couponId: json['coupon_id'] as int?,
      restaurantId: json['restaurant_id'] as int?,
      code: json['code'] as String,
      description: json['description'] as String?,
      discountType: json['discount_type'] as String,
      discountValue: (json['discount_value'] is int)
          ? (json['discount_value'] as int).toDouble()
          : json['discount_value'] as double,
      minOrderValue: json['min_order_value'] != null
          ? (json['min_order_value'] is int)
              ? (json['min_order_value'] as int).toDouble()
              : json['min_order_value'] as double
          : null,
      maxDiscount: json['max_discount'] != null
          ? (json['max_discount'] is int)
              ? (json['max_discount'] as int).toDouble()
              : json['max_discount'] as double
          : null,
      usageLimit: json['usage_limit'] as int?,
      usageLimitPerUser: json['usage_limit_per_user'] as int?,
      validFrom: DateTime.parse(json['valid_from'] as String),
      validUntil: DateTime.parse(json['valid_until'] as String),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Converts the Coupon instance to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'coupon_id': couponId,
      'restaurant_id': restaurantId,
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_value': minOrderValue,
      'max_discount': maxDiscount,
      'usage_limit': usageLimit,
      'usage_limit_per_user': usageLimitPerUser,
      'valid_from': validFrom.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
