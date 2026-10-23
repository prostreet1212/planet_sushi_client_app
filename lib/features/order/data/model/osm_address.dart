class OsmAddress {
  final String name;
  final String city;
  final String street;
  final String housenumber;
  final String country;
  final String countryCode;
  final String postcode;
  final double longitude;
  final double latitude;

  OsmAddress({
    required this.name,
    required this.city,
    required this.street,
    required this.housenumber,
    required this.country,
    required this.countryCode,
    required this.postcode,
    required this.longitude,
    required this.latitude,
  });

  String get formattedAddress {
    if (city.isEmpty || street.isEmpty) return '';
    return [city, street, housenumber].where((e) => e.isNotEmpty).join(', ');
  }

  factory OsmAddress.fromJson(Map<String, dynamic> json) {
    final props = json['properties'] as Map<String, dynamic>? ?? {};
    final geom = json['geometry'] as Map<String, dynamic>? ?? {};
    final coords = (geom['coordinates'] as List?) ?? [null, null];

    return OsmAddress(
      name: props['name']??'',
      city: props['city'] ??'',
      street: props['street'] ??'',
      housenumber: props['housenumber'] ??'',
      country: props['country'] ??'',
      countryCode: props['countrycode']??'',
      postcode: props['postcode'] ??'',
      // ВАЖНО: coordinates = [lon, lat]
      //longitude: (coords[0] as num?)?.toDouble(),
      //latitude: (coords[1] as num?)?.toDouble(),
      longitude: coords[0]??0.0,
      latitude: coords[1]??0.0,
    );
  }
}