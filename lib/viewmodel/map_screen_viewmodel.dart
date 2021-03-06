import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkingapp/model/markers_model.dart';
import 'package:parkingapp/model/places_model.dart';
import 'package:parkingapp/utilities/Database/database_helper.dart';
import 'package:parkingapp/utilities/Database/paking_spot_fields.dart';
import 'dart:convert';
import 'package:parkingapp/utilities/constants.dart' as Constants;
import 'package:http/http.dart' as http;

class MapScreenViewModel extends ChangeNotifier {
  List<PlaceSearch> suggestions = [];
  List<MarkersDetails> allParking = [];
  int ratings = 1;
  String names = '';
  String descriptions = '';
  bool showDetails = false;
  Set<Marker> markers = {};
  void setDetailsFalse() {
    showDetails = false;
    notifyListeners();
  }

  void getData(String value) async {
    clearSuggestions();
    http.Response response = await http
        .get(Uri.parse('${Constants.url}$value&key=${Constants.key}'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var singleData in data['results']) {
        suggestions.add(PlaceSearch.fromJson(singleData));
      }
    }
    notifyListeners();
  }

  void initialMarker() async {
    var myDb = DataBaseHelper.instance;
    var future = await myDb.queryAll();
    Iterable<MarkersDetails> _markers =
        (future).map((e) => MarkersDetails.fromJson(e));
    for (var value in _markers) {
      allParking.add(value);
      markers.add(
        Marker(
          markerId: MarkerId('${value.id}'),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(value.latitude, value.longitude),
          consumeTapEvents: true,
          //infoWindow: InfoWindow(title: name, snippet: description),
          onTap: () {
            showDetails = true;
            this.ratings = value.rating;
            this.names = value.name;
            this.descriptions = value.description;
            print('sdd');
            notifyListeners();
          },
        ),
      );
    }
    notifyListeners();
  }

  void emptySuggestions() {
    suggestions = [];
    notifyListeners();
  }

  void clearSuggestions() {
    suggestions.clear();
    notifyListeners();
  }

  void addMarker(double latitude, double longitude, String name,
      String description, int rating) async {
    print(latitude);
    print(longitude);
    print(name);
    print(description);
    print(rating);
    allParking.add(MarkersDetails(
        description: description,
        rating: rating,
        id: allParking.length + 1,
        name: name,
        longitude: longitude,
        latitude: latitude));
    var myDb = DataBaseHelper.instance;
    var row = {
      '${ParkingSpotsFields.name}': name,
      '${ParkingSpotsFields.latitude}': latitude,
      '${ParkingSpotsFields.longitude}': longitude,
      '${ParkingSpotsFields.description}': description,
      '${ParkingSpotsFields.rating}': rating,
    };
    await myDb.insert(row);
    markers.add(
      Marker(
        markerId: MarkerId('id-${markers.length + 1}'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(latitude, longitude),
        consumeTapEvents: true,
        //infoWindow: InfoWindow(title: name, snippet: description),
        onTap: () {
          showDetails = true;
          this.ratings = rating;
          this.names = name;
          this.descriptions = description;
          print('sdfgf');
          notifyListeners();
        },
      ),
    );
    notifyListeners();
  }
}
