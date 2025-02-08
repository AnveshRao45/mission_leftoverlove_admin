import 'package:equatable/equatable.dart';

class OwnerModel extends Equatable {
  final String ownerId;
  final int? restaurantId;
  final String name;
  final String email;
  final String phoneNumber;

  const OwnerModel({
    required this.ownerId,
    required this.restaurantId,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  // Convert from Supabase (PostgreSQL) Map to Model
  factory OwnerModel.fromMap(Map<String, dynamic> map) {
    return OwnerModel(
      ownerId: map['owner_id'],
      restaurantId: map['restaurant_id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
    );
  }

  // Convert Model to Map (for inserting/updating in Supabase)
  Map<String, dynamic> toMap() {
    return {
      'owner_id': ownerId,
      'restaurant_id': restaurantId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [
        ownerId,
        restaurantId,
        name,
        email,
        phoneNumber,
      ];
}
