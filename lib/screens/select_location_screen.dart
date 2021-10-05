import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingapp/components/button.dart';
import 'package:parkingapp/screens/add_parking_screen.dart';
import 'package:parkingapp/utilities/providers.dart';
import 'package:parkingapp/utilities/constants.dart';

class SelectLocationScreen extends StatefulWidget {
  SelectLocationScreen(this.lat, this.lon);
  final lat;
  final lon;
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  FocusNode _focusNode = FocusNode();
  late GoogleMapController _googleMapController;
  Completer<GoogleMapController> _mapController = Completer();
  final _locationController = TextEditingController();
  @override
  void initState() {
    context.read(selectScreenProvider).setLocation(widget.lat, widget.lon);
    super.initState();
  }

  _handleTap(LatLng tappedPoint) {
    context
        .read(selectScreenProvider)
        .addMarker(tappedPoint.latitude, tappedPoint.longitude);
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
                return Expanded(
                  child: Stack(
                    children: [
                      Consumer(
                        builder: (BuildContext context,
                            T Function<T>(ProviderBase<Object?, T>) watch,
                            Widget? child) {
                          final marker = watch(selectScreenProvider).markers;
                          final lat = watch(selectScreenProvider).lat;
                          final lon = watch(selectScreenProvider).lon;
                          return GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: false,
                            onTap: _handleTap,
                            markers: marker,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                lat!,
                                lon!,
                              ),
                              zoom: 14,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController.complete(controller);
                              _googleMapController = controller;
                            },
                          );
                        },
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
                                    context
                                        .read(selectScreenProvider)
                                        .addMarker(suggestion[index].latitude,
                                            suggestion[index].longitude);
                                  },
                                );
                              }),
                        ),
                      Positioned(
                        bottom: 60,
                        left: 40,
                        right: 40,
                        child: Center(
                          child: CommonButton(
                              text: 'Submit',
                              onClick: () {
                                print(
                                    'lat ${context.read(selectScreenProvider).lat}');
                                print(
                                    'lon ${context.read(selectScreenProvider).lon}');
                                Navigator.pop(
                                    context,
                                    LatLng(
                                        context.read(selectScreenProvider).lat,
                                        context
                                            .read(selectScreenProvider)
                                            .lon));
                              }),
                        ),
                      )
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
