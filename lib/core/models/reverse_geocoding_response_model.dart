class ReverseGeocodeResponse {
  final List<Feature>? features;

  ReverseGeocodeResponse({this.features});

  factory ReverseGeocodeResponse.fromJson(Map<String, dynamic> json) {
    return ReverseGeocodeResponse(
      features: (json['features'] as List?)
          ?.map((feature) => Feature.fromJson(feature))
          .toList(),
    );
  }
}

class Feature {
  final String? id;
  final Geometry? geometry;
  final Properties? properties;

  Feature({
    this.id,
    this.geometry,
    this.properties,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      geometry:
          json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null,
      properties: json['properties'] != null
          ? Properties.fromJson(json['properties'])
          : null,
    );
  }
}

class Geometry {
  final String? type;
  final List<double>? coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'])
          : null,
    );
  }
}

class Properties {
  final String? mapboxId;
  final String? featureType;
  final String? fullAddress;
  final String? name;
  final String? namePreferred;
  final Coordinates? coordinates;
  final String? placeFormatted;
  final List<double>? bbox;
  final Context? context;

  Properties({
    this.mapboxId,
    this.featureType,
    this.fullAddress,
    this.name,
    this.namePreferred,
    this.coordinates,
    this.placeFormatted,
    this.bbox,
    this.context,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      mapboxId: json['mapbox_id'],
      featureType: json['feature_type'],
      fullAddress: json['full_address'],
      name: json['name'],
      namePreferred: json['name_preferred'],
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      placeFormatted: json['place_formatted'],
      bbox: json['bbox'] != null ? List<double>.from(json['bbox']) : null,
      context:
          json['context'] != null ? Context.fromJson(json['context']) : null,
    );
  }
}

class Coordinates {
  final double? longitude;
  final double? latitude;

  Coordinates({
    this.longitude,
    this.latitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class Context {
  final Place? place;
  final District? district;
  final Region? region;
  final Country? country;
  final Locality? locality;

  Context({
    this.place,
    this.district,
    this.region,
    this.country,
    this.locality,
  });

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      place: json['place'] != null ? Place.fromJson(json['place']) : null,
      district:
          json['district'] != null ? District.fromJson(json['district']) : null,
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      locality:
          json['locality'] != null ? Locality.fromJson(json['locality']) : null,
    );
  }
}

class Place {
  final String? mapboxId;
  final String? name;
  final String? wikidataId;

  Place({
    this.mapboxId,
    this.name,
    this.wikidataId,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      mapboxId: json['mapbox_id'],
      name: json['name'],
      wikidataId: json['wikidata_id'],
    );
  }
}

class District {
  final String? mapboxId;
  final String? name;
  final String? wikidataId;

  District({
    this.mapboxId,
    this.name,
    this.wikidataId,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      mapboxId: json['mapbox_id'],
      name: json['name'],
      wikidataId: json['wikidata_id'],
    );
  }
}

class Region {
  final String? mapboxId;
  final String? name;
  final String? wikidataId;
  final String? regionCode;
  final String? regionCodeFull;

  Region({
    this.mapboxId,
    this.name,
    this.wikidataId,
    this.regionCode,
    this.regionCodeFull,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      mapboxId: json['mapbox_id'],
      name: json['name'],
      wikidataId: json['wikidata_id'],
      regionCode: json['region_code'],
      regionCodeFull: json['region_code_full'],
    );
  }
}

class Country {
  final String? mapboxId;
  final String? name;
  final String? wikidataId;
  final String? countryCode;
  final String? countryCodeAlpha3;

  Country({
    this.mapboxId,
    this.name,
    this.wikidataId,
    this.countryCode,
    this.countryCodeAlpha3,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      mapboxId: json['mapbox_id'],
      name: json['name'],
      wikidataId: json['wikidata_id'],
      countryCode: json['country_code'],
      countryCodeAlpha3: json['country_code_alpha_3'],
    );
  }
}

class Locality {
  final String? mapboxId;
  final String? name;
  final String? wikidataId;

  Locality({
    this.mapboxId,
    this.name,
    this.wikidataId,
  });

  factory Locality.fromJson(Map<String, dynamic> json) {
    return Locality(
      mapboxId: json['mapbox_id'],
      name: json['name'],
      wikidataId: json['wikidata_id'],
    );
  }
}
