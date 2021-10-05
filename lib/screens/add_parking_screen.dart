import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkingapp/components/button.dart';
import 'package:parkingapp/components/text_field.dart';
import 'package:parkingapp/screens/select_location_screen.dart';
import 'package:parkingapp/utilities/constants.dart';
import 'package:parkingapp/utilities/providers.dart';

class AddParkingScreen extends StatefulWidget {
  AddParkingScreen({required this.longitude, required this.latitude});
  final double latitude, longitude;
  @override
  _AddParkingScreenState createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {
  final TextEditingController _parkingName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  double? longitude, latitude;
  Set<Marker> _markers = {};

  // Set<Marker> _markers = {31.5619,74.3480};
  late GoogleMapController _googleMapController;
  Completer<GoogleMapController> _mapController = Completer();
  void setLocation() {
    latitude = widget.latitude;
    longitude = widget.longitude;
  }

  @override
  void initState() {
    setLocation();
    _markers.add(Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: MarkerId('id-1'),
      position: LatLng(latitude!, longitude!),
    )); // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kTealBasic,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    width: double.infinity,
                    height: screenSize.height * 0.85,
                    margin: EdgeInsets.only(top: 18),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22)),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                              child: Text(
                            ('Add Parking'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 33.0,
                                color: kTealBasic),
                          )),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          StyledTextField(
                            prefixIcon: (Icons.local_parking),
                            controller: _parkingName,
                            labelText: 'Parking Name',
                            isObscureText: false,
                            maxLines: 1,
                          ),
                          Consumer(
                            builder: (BuildContext context, watch, _) {
                              final error = watch(addScreenProvide).errorName;
                              return Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    error,
                                    style: TextStyle(color: Colors.red),
                                  ));
                            },
                          ),
                          StyledTextField(
                            prefixIcon: (Icons.description),
                            controller: _description,
                            labelText: 'Description',
                            isObscureText: false,
                            maxLines: 3,
                          ),
                          Consumer(
                            builder: (BuildContext context, watch, _) {
                              final error =
                                  watch(addScreenProvide).errorDescription;
                              return Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    error,
                                    style: TextStyle(color: Colors.red),
                                  ));
                            },
                          ),
                          Container(
                            height: screenSize.height * 0.25,
                            decoration: BoxDecoration(
                              border: Border.all(color: kTealBasic),
                              //  borderRadius: BorderRadius.circular(22),
                            ),
                            child: GoogleMap(
                              onTap: (value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectLocationScreen(
                                        value.latitude, value.longitude),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    var camera = CameraPosition(
                                      target: LatLng(
                                        value.latitude,
                                        value.longitude,
                                      ),
                                      zoom: 14,
                                    );
                                    _googleMapController.animateCamera(
                                        CameraUpdate.newCameraPosition(camera));
                                    latitude = value.latitude;
                                    longitude = value.longitude;
                                    setState(() {
                                      _markers.clear();
                                      _markers.add(Marker(
                                        icon: BitmapDescriptor.defaultMarker,
                                        markerId: MarkerId('id-1'),
                                        position: LatLng(latitude!, longitude!),
                                      ));
                                    });
                                  }
                                });
                              },
                              mapType: MapType.normal,
                              // myLocationButtonEnabled: true,
                              myLocationEnabled: true,
                              markers: _markers,
                              myLocationButtonEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(latitude!, longitude!),
                                zoom: 14,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _mapController.complete(controller);
                                _googleMapController = controller;
                              },
                            ),
                          ),
                          Consumer(
                            builder: (BuildContext context, watch, _) {
                              final ratings =
                                  watch(addScreenProvide).ratingValue;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        context
                                            .read(addScreenProvide)
                                            .setRating(1);
                                      },
                                      child: Icon(
                                        ratings >= 1
                                            ? Icons.star
                                            : Icons.star_outline_outlined,
                                        color: kTealBasic,
                                      )),
                                  InkWell(
                                      onTap: () {
                                        context
                                            .read(addScreenProvide)
                                            .setRating(2);
                                      },
                                      child: Icon(
                                        ratings >= 2
                                            ? Icons.star
                                            : Icons.star_outline_outlined,
                                        color: kTealBasic,
                                      )),
                                  InkWell(
                                      onTap: () {
                                        context
                                            .read(addScreenProvide)
                                            .setRating(3);
                                      },
                                      child: Icon(
                                        ratings >= 3
                                            ? Icons.star
                                            : Icons.star_outline_outlined,
                                        color: kTealBasic,
                                      )),
                                  InkWell(
                                      onTap: () {
                                        context
                                            .read(addScreenProvide)
                                            .setRating(4);
                                      },
                                      child: Icon(
                                        ratings >= 4
                                            ? Icons.star
                                            : Icons.star_outline_outlined,
                                        color: kTealBasic,
                                      )),
                                  InkWell(
                                      onTap: () {
                                        context
                                            .read(addScreenProvide)
                                            .setRating(5);
                                      },
                                      child: Icon(
                                        ratings >= 5
                                            ? Icons.star
                                            : Icons.star_outline_outlined,
                                        color: kTealBasic,
                                      )),
                                ],
                              );
                            },
                          ),
                          CommonButton(
                            text: 'Submit',
                            onClick: () {
                              if (_parkingName.text.isEmpty ||
                                  _description.text.isEmpty) {
                                if (_parkingName.text.isEmpty) {
                                  context
                                      .read(addScreenProvide)
                                      .setErrorName('Please Enter Name');
                                }
                                if (_description.text.isEmpty) {
                                  context
                                      .read(addScreenProvide)
                                      .setErrorDescription(
                                          'Please Enter Description');
                                }
                              } else {
                                context.read(mainMapScreenProvider).addMarker(
                                      latitude!,
                                      longitude!,
                                      _parkingName.text,
                                      _description.text,
                                      context
                                          .read(addScreenProvide)
                                          .ratingValue,
                                    );
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
