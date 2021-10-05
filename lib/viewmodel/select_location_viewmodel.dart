import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationViewModel extends ChangeNotifier {
  Set<Marker> markers = {};
  late double lat, lon;
  setLocation(double latitude, double longitude) {
    lat = latitude;
    lon = longitude;
    notifyListeners();
  }

  addMarker(double latitude, double longitude) {
    setLocation(latitude, longitude);
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId('id-1'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(latitude, longitude),
      ),
    );
    notifyListeners();
  }
}
