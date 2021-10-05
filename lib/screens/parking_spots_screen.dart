import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingapp/screens/add_parking_screen.dart';
import 'package:parkingapp/utilities/providers.dart';
import 'package:parkingapp/utilities/constants.dart';

class MapScreen extends StatefulWidget {
  MapScreen(this.lat, this.lon);
  final lat;
  final lon;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  FocusNode _focusNode = FocusNode();
  late GoogleMapController _googleMapController;
  Completer<GoogleMapController> _mapController = Completer();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read(mainMapScreenProvider).initialMarker();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kTealBasic,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddParkingScreen(
                  latitude: widget.lat,
                  longitude: widget.lon,
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: kTealBasic,
          title: Center(
            child: Text('Parking'),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              margin: EdgeInsets.only(
                top: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(20),
              ),
              child: TextField(
                onChanged: (value) {
                  context.read(mainMapScreenProvider).getData(value);
                },
                onTap: () {
                  context.read(mainMapScreenProvider).setDetailsFalse();
                },
                focusNode: _focusNode,
                controller: _locationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color: kTealBasic,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color: kTealBasic,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color: kTealBasic,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Search..',
                ),
              ),
            ),
            Consumer(
              builder: (BuildContext context, watch, _) {
                final suggestion = watch(mainMapScreenProvider).suggestions;
                final _marker = watch(mainMapScreenProvider).markers;
                print(_marker.length);
                return Expanded(
                  child: Stack(
                    children: [
                      Container(
                        child: GoogleMap(
                          onTap: (value) {
                            context
                                .read(mainMapScreenProvider)
                                .setDetailsFalse();
                          },
                          mapType: MapType.normal,
                          zoomControlsEnabled: false,
                          markers: _marker,
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
                      if (suggestion.length != 0)
                        Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            )),
                      if (suggestion.length != 0)
                        Container(
                          height: 300.0,
                          child: ListView.builder(
                              itemCount: suggestion.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    suggestion[index].description,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    var cameraPoint = CameraPosition(
                                      target: LatLng(
                                        suggestion[index].latitude,
                                        suggestion[index].longitude,
                                      ),
                                      zoom: 14,
                                    );
                                    context
                                        .read(mainMapScreenProvider)
                                        .emptySuggestions();
                                    _locationController.clear();
                                    _focusNode.unfocus();
                                    _googleMapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            cameraPoint));
                                  },
                                );
                              }),
                        ),
                      Positioned(
                        bottom: 0,
                        child: Consumer(
                          builder: (BuildContext context,
                              T Function<T>(ProviderBase<Object?, T>) watch,
                              Widget? child) {
                            final rating = watch(mainMapScreenProvider).ratings;
                            final String name =
                                watch(mainMapScreenProvider).names;
                            final bool show =
                                watch(mainMapScreenProvider).showDetails;
                            final String description =
                                watch(mainMapScreenProvider).descriptions;
                            return Visibility(
                              visible: show,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.9,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: $name',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Description: $description',
                                            style: TextStyle(fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                          Row(
                                            children: [
                                              for (int i = 0; i < rating; i++)
                                                Icon(
                                                  Icons.star,
                                                  color: kTealBasic,
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
