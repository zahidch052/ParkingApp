import 'package:parkingapp/utilities/Database/paking_spot_fields.dart';

class MarkersDetails {
  double latitude;
  double longitude;
  int id;
  String name;
  String description;
  int rating;
  MarkersDetails(
      {required this.description,
      required this.rating,
      required this.id,
      required this.name,
      required this.longitude,
      required this.latitude});
  factory MarkersDetails.fromJson(Map<String, dynamic> jsonMap) {
    // print(jsonMap);
    return MarkersDetails(
      description: jsonMap.containsKey(ParkingSpotsFields.description)
          ? jsonMap[ParkingSpotsFields.description]
          : 'Default Description',
      name: jsonMap.containsKey(ParkingSpotsFields.name)
          ? jsonMap[ParkingSpotsFields.name]
          : 'Default Name',
      id: jsonMap.containsKey(ParkingSpotsFields.identifier)
          ? jsonMap[ParkingSpotsFields.identifier]
          : 1,
      latitude: jsonMap.containsKey(ParkingSpotsFields.latitude)
          ? jsonMap[ParkingSpotsFields.latitude]
          : 31.5619,
      longitude: jsonMap.containsKey(ParkingSpotsFields.longitude)
          ? jsonMap[ParkingSpotsFields.longitude]
          : 74.3480,
      rating: jsonMap.containsKey(ParkingSpotsFields.rating)
          ? jsonMap[ParkingSpotsFields.rating]
          : 1,
    );
  }
}
