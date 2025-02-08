class MapboxSuggestions {
  List<Suggestion>? suggestions;
  String? attribution;
  String? responseId;
  String? url;

  MapboxSuggestions({
    this.suggestions,
    this.attribution,
    this.responseId,
    this.url,
  });

  factory MapboxSuggestions.fromJson(Map<String, dynamic> json) {
    return MapboxSuggestions(
      suggestions: (json['suggestions'] as List?)
          ?.map((e) => Suggestion.fromJson(e))
          .toList(),
      attribution: json['attribution'],
      responseId: json['response_id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suggestions': suggestions?.map((e) => e.toJson()).toList(),
      'attribution': attribution,
      'response_id': responseId,
      'url': url,
    };
  }
}

class Suggestion {
  String? name;
  String? mapboxId;
  String? featureType;
  String? placeFormatted;
  Context? context;
  String? language;
  String? maki;
  Map<String, dynamic>? metadata;
  double? distance;
  String? address;
  String? fullAddress;
  List<String>? poiCategory;
  List<String>? poiCategoryIds;
  String? operationalStatus;

  Suggestion({
    this.name,
    this.mapboxId,
    this.featureType,
    this.placeFormatted,
    this.context,
    this.language,
    this.maki,
    this.metadata,
    this.distance,
    this.address,
    this.fullAddress,
    this.poiCategory,
    this.poiCategoryIds,
    this.operationalStatus,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      name: json['name'],
      mapboxId: json['mapbox_id'],
      featureType: json['feature_type'],
      placeFormatted: json['place_formatted'],
      context:
          json['context'] != null ? Context.fromJson(json['context']) : null,
      language: json['language'],
      maki: json['maki'],
      metadata: json['metadata'] ?? {},
      distance: (json['distance'] as num?)?.toDouble(),
      address: json['address'],
      fullAddress: json['full_address'],
      poiCategory: (json['poi_category'] as List?)?.cast<String>(),
      poiCategoryIds: (json['poi_category_ids'] as List?)?.cast<String>(),
      operationalStatus: json['operational_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mapbox_id': mapboxId,
      'feature_type': featureType,
      'place_formatted': placeFormatted,
      'context': context?.toJson(),
      'language': language,
      'maki': maki,
      'metadata': metadata,
      'distance': distance,
      'address': address,
      'full_address': fullAddress,
      'poi_category': poiCategory,
      'poi_category_ids': poiCategoryIds,
      'operational_status': operationalStatus,
    };
  }
}

class Context {
  Country? country;
  Region? region;
  District? district;
  Place? place;
  Postcode? postcode;
  Neighborhood? neighborhood;
  Street? street;

  Context({
    this.country,
    this.region,
    this.district,
    this.place,
    this.postcode,
    this.neighborhood,
    this.street,
  });

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      region: json['region'] != null ? Region.fromJson(json['region']) : null,
      district:
          json['district'] != null ? District.fromJson(json['district']) : null,
      place: json['place'] != null ? Place.fromJson(json['place']) : null,
      postcode:
          json['postcode'] != null ? Postcode.fromJson(json['postcode']) : null,
      neighborhood: json['neighborhood'] != null
          ? Neighborhood.fromJson(json['neighborhood'])
          : null,
      street: json['street'] != null ? Street.fromJson(json['street']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country?.toJson(),
      'region': region?.toJson(),
      'district': district?.toJson(),
      'place': place?.toJson(),
      'postcode': postcode?.toJson(),
      'neighborhood': neighborhood?.toJson(),
      'street': street?.toJson(),
    };
  }
}

class Country {
  String? id;
  String? name;
  String? countryCode;
  String? countryCodeAlpha3;

  Country({
    this.id,
    this.name,
    this.countryCode,
    this.countryCodeAlpha3,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      countryCode: json['country_code'],
      countryCodeAlpha3: json['country_code_alpha_3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country_code': countryCode,
      'country_code_alpha_3': countryCodeAlpha3,
    };
  }
}

class Region {
  String? id;
  String? name;
  String? regionCode;
  String? regionCodeFull;

  Region({
    this.id,
    this.name,
    this.regionCode,
    this.regionCodeFull,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      regionCode: json['region_code'],
      regionCodeFull: json['region_code_full'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region_code': regionCode,
      'region_code_full': regionCodeFull,
    };
  }
}

class District {
  String? id;
  String? name;

  District({this.id, this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Place {
  String? id;
  String? name;

  Place({this.id, this.name});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Postcode {
  String? id;
  String? name;

  Postcode({this.id, this.name});

  factory Postcode.fromJson(Map<String, dynamic> json) {
    return Postcode(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Neighborhood {
  String? id;
  String? name;

  Neighborhood({this.id, this.name});

  factory Neighborhood.fromJson(Map<String, dynamic> json) {
    return Neighborhood(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Street {
  String? name;

  Street({this.name});

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
