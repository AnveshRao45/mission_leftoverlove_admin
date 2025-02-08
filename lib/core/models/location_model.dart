// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LocationModel {
  final String locationName;
  final double lat;
  final double lng;
  LocationModel({
    required this.locationName,
    required this.lat,
    required this.lng,
  });

  LocationModel copyWith({
    String? locationName,
    double? lat,
    double? lng,
  }) {
    return LocationModel(
      locationName: locationName ?? this.locationName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'locationName': locationName,
      'lat': lat,
      'lng': lng,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      locationName: map['locationName'] as String,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LocationModel(locationName: $locationName, lat: $lat, lng: $lng)';

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.locationName == locationName &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode => locationName.hashCode ^ lat.hashCode ^ lng.hashCode;
}
