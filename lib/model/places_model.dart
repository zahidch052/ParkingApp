class PlaceSearch {
  final String description;
  final double latitude;
  final double longitude;

  PlaceSearch(
      {required this.description,
      required this.longitude,
      required this.latitude});

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        description: json['formatted_address'],
        latitude: json['geometry']['location']['lat'],
        longitude: json['geometry']['location']['lng']);
  }
}
