import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: MapScreen(31.5619,
            74.3480), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

const url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=';
const key = 'AIzaSyDWz4MXEMykzJcVA6Wy24DXh2v1QyTzkyM';

class ScreenArguments {
  var cameraPosition;
  String des;
  ScreenArguments(this.cameraPosition, this.des);
}

class MapScreen extends StatefulWidget {
  MapScreen(this.lat, this.lon);
  final lat;
  final lon;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double? latitude;
  List<PlaceSearch> suggestions = [];
  double? longitude;
  Set<Marker> _markers = {};
  late GoogleMapController _googleMapController;
  Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription locationSubscription;
  late StreamSubscription boundsSubscription;
  final _locationController = TextEditingController();

  @override
  void initState() {
    setLocation(widget.lat, widget.lon);
    super.initState();
  }

  Future<List<PlaceSearch>> getData(String value) async {
    List<PlaceSearch> suggestions = [];
    http.Response response = await http.get(Uri.parse('$url$value&key=$key'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var singleData in data['results']) {
        suggestions.add(PlaceSearch.fromJson(singleData));
      }
    }

    return suggestions;
  }

  void setLocation(double lat, double lon) {
    latitude = lat;
    longitude = lon;
  }

  @override
  void dispose() {
    _locationController.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) async {
                    suggestions.clear();
                    List<PlaceSearch> data = await getData(value);
                    setState(() {
                      suggestions = data;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search..',
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        markers: _markers,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            widget.lat,
                            widget.lon,
                          ),
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                          _googleMapController = controller;
                        },
                      ),
                    ),
                    if (suggestions.length != 0)
                      Container(
                          height: 300.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          )),
                    if (suggestions.length != 0)
                      Container(
                        height: 300.0,
                        child: ListView.builder(
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  suggestions[index].description,
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  var cameraPoint = CameraPosition(
                                    target: LatLng(
                                      suggestions[index].latitude,
                                      suggestions[index].longitude,
                                    ),
                                    zoom: 14,
                                  );
                                  setState(() {
                                    suggestions.length = 0;
                                  });
                                  _googleMapController.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          cameraPoint));
                                },
                              );
                            }),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
